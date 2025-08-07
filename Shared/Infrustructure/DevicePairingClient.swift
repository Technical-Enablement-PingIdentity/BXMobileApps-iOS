//
//  AuthNClient.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/14/23.
//

import SwiftUI
import AppAuth
import PingOneSDK

class DevicePairingClient {
    
    // Need this to be a singleton
    public static var currentAuthorizationFlow: OIDExternalUserAgentSession? = nil
    
    private var oidcConfiguration: OIDServiceConfiguration? = nil
    
    init(completionHandler: @escaping (Bool) -> Void) {
        guard let issuer = URL(string: K.PingOne.issuer) else {
            fatalError( "Issuer URL in constants is invalid")
        }
        

        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { config, error in
            guard let config else {
                print("Error retrieving discovery configuration \(error?.localizedDescription ?? "Unknown Error")")
                completionHandler(false)
                return
            }
            
            print("Got issuer configuration: \(config)")
            
            self.oidcConfiguration = config
            completionHandler(true)
        }

    }
    
    func pairDevice(username: String? = nil, approvePairingHandler: @escaping (PairingObject?) -> Void) {
        
        guard let oidcConfiguration else {
            print("Unable to pair a device, oidcConfiguration is nil")
            return
        }
        
        guard let redirectUrl = URL(string: K.PingOne.redirectUri) else {
            print("Unable to pair a device, redirect URL is invalid")
            return
        }
        
        guard let viewController = UIUtilities.getRootViewController() else {
            print("Unable to get root view controller")
            return
        }
        

        PingOne.generateMobilePayload { payload, error in
            if let error {
                print("Unable to generate mobile payload \(error)")
            } else if let payload {
                var additionalParameters = [K.Oidc.MobilePayload: payload, K.Oidc.Prompt: K.Oidc.LoginPrompt]
                
                if let username {
                    additionalParameters[K.Oidc.LoginHint] = username
                }
                
                let authRequest = OIDAuthorizationRequest(configuration: oidcConfiguration, clientId: K.PingOne.clientId, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: redirectUrl, responseType: OIDResponseTypeCode, additionalParameters: additionalParameters)
                
                DevicePairingClient.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: authRequest, presenting: viewController) { authState, error in
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
            }
        }
    }
    
    private func processIdToken(idToken: String, approvePairingHandler: @escaping (PairingObject?) -> Void) {
        print("ID Token: \(idToken)")
        PingOne.processIdToken(idToken) { pairingObject, error in
            guard let pairingObject else {
                print("An error occurred processing ID Token \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            // Display Notification Alert
            approvePairingHandler(pairingObject)
        }
    }
}
