//
//  DeviceParinginClient.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/14/23.
//

import Foundation
import AppAuth
import PingOneSDK

class DevicePairingClient {
    
    private let issuer: URL
    private let redirectUri: URL
    private let clientId: String
    
    private var oidcConfiguration: OIDServiceConfiguration? = nil
    
    var clientReady = false
    
    init(issuer: URL, redirectUri: URL, clientId: String) {
        self.issuer = issuer
        self.redirectUri = redirectUri
        self.clientId = clientId
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: self.issuer) { config, error in
            guard let config else {
                print("Error retrieving discovery configuration \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            print("Got issuer configuration: \(config)")
            
            self.oidcConfiguration = config
            self.clientReady = true
        }
    }
    
    func pairDevice(appDelegate: AppDelegate, viewController: UIViewController, approvePairingHandler: @escaping (PairingObject?) -> Void) {
        
        guard let oidcConfiguration else {
            print("Unable to pair a device, oidcConfiguration is nil")
            return
        }
        
        do {
            let payload = try PingOne.generateMobilePayload()
            
            let authRequest = OIDAuthorizationRequest(configuration: oidcConfiguration, clientId: clientId, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: redirectUri, responseType: OIDResponseTypeCode, additionalParameters: [OidcConstants.mobilePayload: payload, OidcConstants.prompt: OidcConstants.loginPrompt])
            
            appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: authRequest, presenting: viewController) { authState, error in
                if let tokenResponse = authState?.lastTokenResponse {
                    print("Got authorization tokens. Access token: \(tokenResponse.accessToken ?? "nil")")
                    
                    if let idToken = tokenResponse.idToken {
                        self.processIdToken(idToken: idToken, approvePairingHandler: approvePairingHandler)
                    } else {
                        print("No ID Token present on token reponse")
                    }

                } else {
                    print("Authorization Error: \(error?.localizedDescription ?? "Unknown Error")")
                }
            }
        } catch let error {
            print("Error creating auth request: \(error)")
        }
    }
    
    private func processIdToken(idToken: String, approvePairingHandler: @escaping (PairingObject?) -> Void) {
        PingOne.processIdToken(idToken) { pairingObject, error in
            guard let pairingObject else {
                print("An error occurred processing ID Token \(error?.localizedDescription ?? "Unkown Error")")
                return
            }
            
            // Display Notification Alert
            approvePairingHandler(pairingObject)
        }
    }
}
