//
//  File.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/19/25.
//

import Foundation
import PingDavinci

@MainActor
class UserViewModel: ObservableObject {
    /// Configures and initializes the DaVinci instance with the PingOne server and OAuth 2.0 client details.
    /// - This configuration includes:
    ///   - Client ID
    ///   - Scopes
    ///   - Redirect URI
    ///   - Discovery Endpoint
    ///   - Other optional fields
    public var loginFlowClient: DaVinci
    
    @Published var clientUsingQa: Bool
    
    @Published var email = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phone = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var postalCode = ""
    
    @Published var isLoggedIn = false
    
    var displayName: String {
        return firstName.isEmpty ? email : firstName
    }
    
    init() {
        UserDefaults.standard.synchronize()
        (loginFlowClient, clientUsingQa) = UserViewModel.createClient()
    }
    
    func refreshLoginClient() async {
        UserDefaults.standard.synchronize()
        let useQaSetting = UserDefaults.standard.bool(forKey: K.DaVinci.useQaSettingKey)
        if useQaSetting != clientUsingQa {
            print("User changed setting, refreshing client")
            await logoutUser()
            (loginFlowClient, clientUsingQa) = UserViewModel.createClient()
        }
    }
    
    func fetchUserInfo() async {
        let userInfoResponse = await loginFlowClient.user()?.userinfo(cache: false)
            
        switch userInfoResponse {
        case .success(let userInfoDictionary):
            await MainActor.run {
                isLoggedIn = true
                
                let address = userInfoDictionary["address"] as? [String: String]
                
                firstName = userInfoDictionary["given_name"] as? String ?? ""
                lastName = userInfoDictionary["family_name"] as? String ?? ""
                email = userInfoDictionary["email"] as? String ?? ""
                phone = userInfoDictionary["mobile_phone"] as? String ?? ""
                streetAddress = address?["street_address"] as? String ?? ""
                city = address?["locality"] as? String ?? ""
                postalCode = address?["postal_code"] as? String ?? ""
            }
        case .failure(let error):
            print("Unexpected Failure fetching userInfo \(error)")
        case .none:
            // This is the result if user is not logged in
            await resetModel()
        }
    }

    func logoutUser() async {
        await loginFlowClient.user()?.logout()
        await resetModel()
    }
    
    func resetModel() async {
        await MainActor.run {
            isLoggedIn = false
            firstName = ""
            lastName = ""
            streetAddress = ""
            city = ""
            postalCode = ""
            email = ""
        }
    }
    
    static func createClient() -> (DaVinci, Bool) {
        let useQaEnvironment = UserDefaults.standard.bool(forKey: K.DaVinci.useQaSettingKey)
        return (DaVinci.createDaVinci { config in
            config.module(OidcModule.config) { oidcValue in
                oidcValue.clientId = useQaEnvironment ? K.DaVinci.qaClientId : K.DaVinci.productionClientId
                oidcValue.scopes = Set(K.DaVinci.scopes)
                oidcValue.redirectUri = K.DaVinci.redirectUri
                oidcValue.discoveryEndpoint = useQaEnvironment ? K.DaVinci.qaIssuer : K.DaVinci.productionIssuer
            }
        }, useQaEnvironment)
    }
}
