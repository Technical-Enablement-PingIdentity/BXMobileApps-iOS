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
    
    private var pingFedAuthClient: PingFedAuthnClient
    
    var loginCompleteCallback: ((String, String, Bool) -> Void)?
    
    @Published var loginStep: LoginStep = .unknown
    @Published var username: String?
    @Published var validationMessage: String?
    @Published var fatalErrorMessage: String?
    @Published var processingPingFedCall = true
    @Published var selectableDevices: [SelectableDevice] = []
    @Published var selectedDevice: SelectableDevice?
    @Published var isPasswordUser = false
    
    init(pingFedBaseUrl: String) {
        pingFedAuthClient = PingFedAuthnClient(appUrl: pingFedBaseUrl)
    }
    
    func startAuthentication(loginCompleteHandler: @escaping (String, String, Bool) -> Void) async throws {
        self.loginCompleteCallback = loginCompleteHandler
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            try await pingFedAuthClient.startAuthn()
            setLoginStep()
            checkIfCompleted()
        } catch {
            fatalErrorMessage = String(localized: "authentication.error")
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
                validationMessage = String(localized: "authentication.username.not_found")
                try await startAuthentication(loginCompleteHandler: self.loginCompleteCallback!)
            } else if loginStep == .authenticationRequired {
                selectableDevices = try await pingFedAuthClient.submitAuthenticate()
                setLoginStep()
                
                if loginStep == .otpRequired {
                    selectedDevice = selectableDevices.first
                }
                
                checkIfCompleted()
            } else {
                self.username = pingFedAuthClient.storedUsername
            }
        } catch {
            fatalErrorMessage = String(localized: "authentication.username.error")
        }
    }
    
    func submitPassword(password: String) async throws {
        self.isPasswordUser = true
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            let signalsData = try await ProtectClient.getSignalsData()
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
                self.fatalErrorMessage = String(localized: "authentication.password.lockout")
            } else {
                // This will probably never get hit but will allow app to successfully log in still if we ever remove the protect step from the AuthN API
                checkIfCompleted()
            }
        } catch {
            fatalErrorMessage = String(localized: "authentication.password.error")
        }
    }
    
    func submitDeviceProfile() async throws {
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            let signalsData = try await ProtectClient.getSignalsData()
            try await pingFedAuthClient.submitDeviceProfile(signalsData: signalsData)
            setLoginStep()
            checkIfCompleted()
        } catch {
            print(error.localizedDescription)
            fatalErrorMessage = String(localized: "authentication.device_profile.error")
        }
    }
    
    func submitDeviceSelection(id: String) async throws {
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            selectedDevice = try await pingFedAuthClient.submitDeviceSelection(deviceId: id)
            setLoginStep()
        } catch {
            print(error.localizedDescription)
            fatalErrorMessage = String(localized: "authentication.device_selection.error")
        }
    }
    
    func submitOneTimePasscode(otp: String) async throws {
        validationMessage = nil
        processingPingFedCall = true
        defer { processingPingFedCall = false }
        
        do {
            let validationMessage = try await pingFedAuthClient.submitOneTimePasscode(otp: otp)
            
            if validationMessage != nil {
                self.validationMessage = validationMessage
                print("Server returned validation error \(validationMessage ?? "nil")")
                return
            }
            
            setLoginStep()
            
            if loginStep == .failed {
                self.fatalErrorMessage = String(localized: "authentication.otp.error")
            } else if loginStep == .mfaCompleted {
                try await pingFedAuthClient.submitContinueAuthentication()
                setLoginStep()
                checkIfCompleted()
            }
        } catch {
            
        }
    }
    
    func checkIfCompleted() {
        if loginStep == .completed {
            guard let accessToken = pingFedAuthClient.accessToken else {
                fatalErrorMessage = String(localized: "authentication.missing_access_token")
                return
            }
            
            guard let loginCompleteCallback else {
                fatalErrorMessage = String(localized: "authentication.missing_callback")
                return
            }
            
            loginCompleteCallback(accessToken, pingFedAuthClient.idToken ?? "", isPasswordUser)
        }
    }
    
    private func setLoginStep() {
        switch pingFedAuthClient.currentStatus {
        case "IDENTIFIER_REQUIRED":
            loginStep = .username
        case "USERNAME_PASSWORD_REQUIRED":
            loginStep = .password
        case "AUTHENTICATION_REQUIRED":
            loginStep = .authenticationRequired
        case "DEVICE_SELECTION_REQUIRED":
            loginStep = .deviceSelection
        case "OTP_REQUIRED":
            loginStep = .otpRequired
        case "MFA_COMPLETED":
            loginStep = .mfaCompleted
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
    case username, password, authenticationRequired, deviceSelection, otpRequired, mfaCompleted, deviceProfileRequired, failed, completed, unknown
}


struct PingOneSignalsError: LocalizedError {
    let description: String
}
