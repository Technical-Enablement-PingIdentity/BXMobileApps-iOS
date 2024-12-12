//
//  AuthStorage.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/28/24.
//

import Foundation

final class AuthStorage {
    static let shared = AuthStorage()
    
    private let accessTokenKey = "BXFINANCE_ACCESS_TOKEN"
    private let idTokenKey = "BXFINANCE_ID_TOKEN"
    
    
    private init() {}
    
    func storeTokens(accessToken: String, idToken: String) {
        do {
            try KeychainManager.shared.saveToken(accessToken, forKey: accessTokenKey)
        } catch let error {
            print("Error saving access token to storage \(error)")
        }
        
        do {
            try KeychainManager.shared.saveToken(idToken, forKey: idTokenKey)
        } catch let error {
            print("Error saving id token to storage \(error)")
        }
        
    }
    
    func getIdToken() -> String? {
        return KeychainManager.shared.getToken(forKey: idTokenKey)
    }
    
    func getAccessToken() -> String? {
        return KeychainManager.shared.getToken(forKey: accessTokenKey)
    }
}
