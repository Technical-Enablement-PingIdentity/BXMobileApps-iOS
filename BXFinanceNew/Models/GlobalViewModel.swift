//
//  GlobalModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

class GlobalViewModel: ObservableObject {
    
    @Published var displayConfirmation = false
    @Published var confirmationTitle = ""
    @Published var confirmationMessage = ""
    @Published var confirmationCompletionHandler: ((Bool) -> Void)? = nil
    
    @Published var toast: Toast?

    @Published var accessToken: String
    @Published var idToken: String
    
    init(accessToken: String = "", idToken: String = "") {
        self.accessToken = accessToken
        self.idToken = idToken
    }
    
    func confirmWithUser(title: String, message: String, completionHandler: @escaping (Bool) -> Void) {
        self.displayConfirmation = true
        self.confirmationTitle = title
        self.confirmationMessage = message
        self.confirmationCompletionHandler = completionHandler
    }
    
    func completeConfirmation(userDidApprove: Bool) {

        self.displayConfirmation = false
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

enum ToastStyle {
    case success
    case warning
    case error
    case info
}

extension ToastStyle {
  var themeColor: Color {
    switch self {
    case .error: return Color.red
    case .warning: return Color.orange
    case .info: return Color.blue
    case .success: return Color.green
    }
  }
  
  var iconFileName: String {
    switch self {
    case .info: return "info.circle.fill"
    case .warning: return "exclamationmark.triangle.fill"
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.circle.fill"
    }
  }
}
