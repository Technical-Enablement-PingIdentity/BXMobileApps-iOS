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
    public let loginFlowClient: DaVinci
    
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
        loginFlowClient = DaVinci.createDaVinci { config in
            config.module(OidcModule.config) { oidcValue in
                oidcValue.clientId = K.DaVinci.clientId
                oidcValue.scopes = Set(K.DaVinci.scopes)
                oidcValue.redirectUri = K.DaVinci.redirectUri
                oidcValue.discoveryEndpoint = K.DaVinci.discoveryEndpoint
            }
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
}
