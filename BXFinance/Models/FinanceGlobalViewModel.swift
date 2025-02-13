//
//  GlobalModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI
import AppAuth

final class FinanceGlobalViewModel: ObservableObject {
    
    static let shared = FinanceGlobalViewModel()

    @Published var accessToken: String
    @Published var idToken: String
    
    init(accessToken: String = "", idToken: String = "") {
        self.accessToken = accessToken
        self.idToken = idToken
    }
    
    func setTokens(accessToken: String, idToken: String) {
        self.accessToken = accessToken
        self.idToken = idToken
    }
    
    func clearTokens() {
        self.accessToken = ""
        self.idToken = ""
    }
    
    func getAttributeFromToken(attribute: String, type: TokenType) -> String {
        switch type {
        case .accessToken:
            return JWTUtilities.decode(jwt: accessToken)[attribute] as? String ?? ""
        case .idToken:
            return JWTUtilities.decode(jwt: idToken)[attribute] as? String ?? ""
        }
    }
    
    enum TokenType {
        case accessToken
        case idToken
    }
}
