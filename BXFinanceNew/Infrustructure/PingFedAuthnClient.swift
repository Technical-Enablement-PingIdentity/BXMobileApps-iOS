//
//  PingFedAuthNClient.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/30/24.
//

import SwiftUI
import SwiftyJSON

final class PingFedAuthnClient {
    
    private let appUrl: String
    
    private var flowId: String?
    
    public var storedUsername: String?
    public var currentStatus: String?
    public var accessToken: String?
    public var idToken: String?
    public var expiresIn: String?
    
    public var nonce = ""
    
    init(appUrl: String) {
        self.appUrl = appUrl
    }
    
    func startAuthn() async throws -> Void {
        // Set a new nonce for authn flow
        nonce = String.random(length: 24)
        
        guard let url = URL(string: "\(appUrl)\(K.PingFed.authnEndpoint)?client_id=\(K.Environment.loginClientId)&response_type=\(K.PingFed.responseType)&response_mode=\(K.PingFed.responseMode)&scope=openid profile email phone address&nonce=\(nonce)") else {
            throw PingFedNetworkError(description: "Could not start Authentication session, invalid URL")
        }
        
        do {
            let request = URLRequest(url: url)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
        
            if let json = try? JSON(data: data) {
                if let id = json["id"].string {
                    flowId = id
                }
                
                if let status = json["status"].string {
                    currentStatus = status
                }
                
                print("Successfully started Authentication session flowId: \(flowId ?? "nil"), status: \(currentStatus ?? "nil")")
            }
        } catch {
            throw PingFedNetworkError(description: "An error occurred starting authentication session: \(error.localizedDescription)")
        }
    }
    
    func submitIdentifier(id: String) async throws -> Void {
        do {
            if let json = try await submitStep(bodyString: "{\"identifier\": \"\(id)\"}", contentType: K.PingFed.Headers.submitIdentifier) {
                
                if let username = json["username"].string {
                    storedUsername = username
                }
                
                if let status = json["status"].string {
                    currentStatus = status
                }
                
                print("Successfully submitted username, username: \(storedUsername ?? "nil") status: \(currentStatus ?? "nil")")
            }
        } catch {
            throw PingFedNetworkError(description: "An error occurred submitting username to ping federate \(error.localizedDescription)")
        }
    }
    
    func submitPassword(password: String, signalsData: String) async throws -> String? {
        guard let storedUsername else {
            throw PingFedNetworkError(description: "No stored username, make sure you have submitted an username first")
        }
        
        do {
            if let json = try await submitStep(bodyString: "{\"username\":\"\(storedUsername)\",\"password\":\"\(password)\",\"captchaResponse\":\"\(signalsData)\"}", contentType: K.PingFed.Headers.submitUsernamePassword) {
                
                if let status = json["status"].string {
                    currentStatus = status
                }
                
                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }
                
                if json["code"].string == "VALIDATION_ERROR" {
                    print("here \(json["details"]), \(json["details"][0]) \(json["details"][0]["userMessage"])")
                    return json["details"][0]["userMessage"].string
                }
                

                print("Successfully submitted password, username: \(storedUsername) status: \(currentStatus ?? "nil")")
            }
            return nil
        } catch {
            throw PingFedNetworkError(description: "An error occurred submitting password to ping federate \(error.localizedDescription)")
        }
    }
    
    func submitDeviceProfile(signalsData: String) async throws -> Void {
        do {
            if let json = try await submitStep(bodyString: "{\"signalsSdkDeviceProfile\":\"\(signalsData)\"}", contentType: K.PingFed.Headers.submitDeviceProfile) {
                
                if let status = json["status"].string {
                    currentStatus = status
                }
                
                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }
                
                print("Successfully submitted device profile, username: \(storedUsername ?? "nil"), accessToken: \(accessToken ?? "nil")")
            }
        } catch {
            throw PingFedNetworkError(description: "An error occurred submitting risk data to ping federate")
        }
    }
    
    private func submitStep(bodyString: String, contentType: String) async throws -> JSON? {
        guard let flowId else {
            throw PingFedNetworkError(description: "flowId was nil, have called startAuthn() to start an authentication session?")
        }
        
        guard let url = URL(string: "\(appUrl)\(K.PingFed.authnFlowEndpoint)/\(flowId)") else {
            throw PingFedNetworkError(description: "Could not build authn flow url")
        }
        
        // user agent: BXFinanceNew/40 CFNetwork/1568.200.51 Darwin/24.1.0
        do {
            guard let jsonData = bodyString.data(using: .utf8) else {
                throw PingFedNetworkError(description: "Failed to encode json data")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(K.PingFed.Headers.xsrfValue, forHTTPHeaderField: K.PingFed.xsrfHeader)
            request.setValue(contentType, forHTTPHeaderField: K.PingFed.contentTypeHeader)
            request.httpBody = jsonData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print(String(decoding: data, as: UTF8.self))
            
            return try? JSON(data: data)
        } catch {
            throw PingFedNetworkError(description: error.localizedDescription)
        }
    }
    
    private func grabTokensFromResponse(json: JSON) throws {
        if let accessToken = json["authorizeResponse"]["access_token"].string {
            self.accessToken = accessToken
        } else {
            throw PingFedNetworkError(description: "Could not find access token in response")
        }
        
        if let idToken = json["authorizeResponse"]["id_token"].string {
            guard JWTUtils.decode(jwt: idToken)["nonce"] as? String ?? "" == nonce else {
                self.nonce = ""
                throw PingFedNetworkError(description: "Nonce doesn't match with id_token")
            }
            
            self.nonce = ""
            self.idToken = idToken
        }
    }
}

struct PingFedNetworkError: LocalizedError {
    let description: String
}

