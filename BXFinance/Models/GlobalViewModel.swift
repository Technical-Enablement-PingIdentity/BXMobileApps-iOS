//
//  GlobalModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI
import AppAuth

class GlobalViewModel: ObservableObject {
    
    static let shared = GlobalViewModel()
    
    @Published var presentConfirmation = false
    @Published var confirmationTitle = ""
    @Published var confirmationMessage = ""
    @Published var confirmationSymbol = ""
    
    var confirmationCompletionHandler: ((Bool) -> Void)? = nil

    @Published var accessToken: String
    @Published var idToken: String
    
    init(accessToken: String = "", idToken: String = "") {
        self.accessToken = accessToken
        self.idToken = idToken
    }
    
    func presentUserConfirmation(title: String, message: String, image: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.presentConfirmation = true
            self.confirmationTitle = title
            self.confirmationMessage = message
            self.confirmationSymbol = image
            self.confirmationCompletionHandler = completionHandler
        }
    }
    
    func completeConfirmation(userDidApprove: Bool) {
        self.presentConfirmation = false

        // When these resets aren't in a slight delay the confirmation jumps a little bit when dismissed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.confirmationTitle = ""
            self.confirmationMessage = ""
            self.confirmationSymbol = ""
        }

        if let completionHandler = self.confirmationCompletionHandler {
            completionHandler(userDidApprove)
            self.confirmationCompletionHandler = nil
        }
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
