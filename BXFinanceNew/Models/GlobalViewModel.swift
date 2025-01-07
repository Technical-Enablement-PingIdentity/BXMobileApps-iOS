//
//  GlobalModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

class GlobalViewModel: ObservableObject {
    
    @Published var presentConfirmation = false
    @Published var confirmationTitle = ""
    @Published var confirmationMessage = ""
    var confirmationCompletionHandler: ((Bool) -> Void)? = nil
    
    @Published var toast: Toast?

    @Published var accessToken: String
    @Published var idToken: String
    
    init(accessToken: String = "", idToken: String = "") {
        self.accessToken = accessToken
        self.idToken = idToken
    }
    
    func presentUserConfirmation(title: String, message: String, completionHandler: @escaping (Bool) -> Void) {
        self.presentConfirmation = true
        self.confirmationTitle = title
        self.confirmationMessage = message
        self.confirmationCompletionHandler = completionHandler
    }
    
    func completeConfirmation(userDidApprove: Bool) {
        self.presentConfirmation = false
        self.confirmationTitle = ""
        self.confirmationMessage = ""
        
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
    
    func showToast(style: ToastStyle, message: String) {
        self.toast = Toast(style: style, message: message)
    }
    
    enum TokenType {
        case accessToken
        case idToken
    }
}
