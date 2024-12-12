//
//  UserModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/9/24.
//

import SwiftUI
import PingOneSignals

@MainActor
class LoginViewModel: ObservableObject {
    private var loginCompleteCallback: ((String, String) -> Void)
    private var pingFedAuthClient: PingFedAuthnClient
    
    @Published var loginStep: LoginStep = .unknown
    @Published var username: String?
    @Published var validationMessage: String?
    @Published var fatalErrorMessage: String?
    @Published var processingPingFedCall = true
    
    init(pingFedBaseUrl: String, loginCompleteCallback: @escaping (String, String) -> Void) {
        pingFedAuthClient = PingFedAuthnClient(appUrl: pingFedBaseUrl)
        self.loginCompleteCallback = loginCompleteCallback
    }
    
    func startAuthentication() async throws {
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            try await pingFedAuthClient.startAuthn()
            setLoginStep()
        } catch {
            fatalErrorMessage = "Could not start an authentication session, please try again or contact support"
        }
    }
    
    func submitUsername(username: String) async throws {
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            try await pingFedAuthClient.submitIdentifier(id: username)
            setLoginStep()
            
            if loginStep == .deviceProfileRequired {
                try await submitDeviceProfile()
            } else if loginStep == .failed {
                validationMessage = "User not found, please ensure you have entered a valid username"
                try await startAuthentication()
            } else {
                self.username = pingFedAuthClient.storedUsername
            }
        } catch {
            fatalErrorMessage = "Could not submit username, please try again or contact support"
        }
    }
    
    func submitPassword(password: String) async throws {
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            let signalsData = try await getSignalsData()
            let validationMessage = try await pingFedAuthClient.submitPassword(password: password, signalsData: signalsData)
            
            if validationMessage != nil {
                self.validationMessage = validationMessage
                print("Server returned validation error \(validationMessage ?? "nil")")
                return
            }
            
            setLoginStep()
            
            if loginStep == .deviceProfileRequired {
                try await submitDeviceProfile()
            } else if loginStep == .failed {
                self.fatalErrorMessage = "Could not authenticate user, your account is locked for 1 minute after 3 failed attempts. Please try again."
            } else {
                // This will probably never get hit but will allow app to successfully log in still if we ever remove the protect step from the AuthN API
                checkIfCompleted()
            }
        } catch {
            fatalErrorMessage = "Could not submit password, please try again or contact support"
        }
    }
    
    func submitDeviceProfile() async throws {
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            let signalsData = try await getSignalsData()
            try await pingFedAuthClient.submitDeviceProfile(signalsData: signalsData)
            setLoginStep()
            checkIfCompleted()
        } catch {
            print(error.localizedDescription)
            fatalErrorMessage = "Could not submit device profile, please try again or contact support"
        }
    }
    
    func checkIfCompleted() {
        if loginStep == .completed {
            guard let accessToken = pingFedAuthClient.accessToken else {
                fatalErrorMessage = "Received completed result from Ping Federate but access token is nil, please contact support"
                return
            }
            
            loginCompleteCallback(accessToken, pingFedAuthClient.idToken ?? "")
        }
    }
    
    private func getSignalsData() async throws -> String {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String, Error>) in
            guard let signals = PingOneSignals.sharedInstance() else {
                continuation.resume(throwing: PingOneSignalsError(description: "Could not get shared PingOneSignals instance"))
                return
            }
            
            signals.getData { data, error in
                if let error {
                    continuation.resume(throwing: PingOneSignalsError(description: "An error occurred getting signals data \(error.localizedDescription)"))
                    return
                }
                
                guard let data else {
                    continuation.resume(throwing: PingOneSignalsError(description: "Signals data is nil"))
                    return
                }
                
                continuation.resume(returning: data)
            }
        })
    }
    
    private func setLoginStep() {
        switch pingFedAuthClient.currentStatus {
        case "IDENTIFIER_REQUIRED":
            loginStep = .username
        case "USERNAME_PASSWORD_REQUIRED":
            loginStep = .password
        case "COMPLETED":
            loginStep = .completed
        case "FAILED":
            loginStep = .failed
        case "DEVICE_PROFILE_REQUIRED":
            loginStep = .deviceProfileRequired
        default:
            print("Unknown status encountered \(pingFedAuthClient.currentStatus ?? "")")
            loginStep = .unknown
        }
    }
}

enum LoginStep {
    case username, password, deviceProfileRequired, failed, completed, unknown
}


struct PingOneSignalsError: LocalizedError {
    let description: String
}
