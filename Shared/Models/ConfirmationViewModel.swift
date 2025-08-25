//
//  GlobalModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

class ConfirmationViewModel: ObservableObject {
    
    static let shared = ConfirmationViewModel()
    
    @Published var presentConfirmation = false
    @Published var confirmationTitle = ""
    @Published var confirmationMessage = ""
    @Published var confirmationSymbol = ""
    
    var confirmationCompletionHandler: ((Bool) -> Void)? = nil
    
    func presentUserConfirmation(title: String, message: String, image: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.confirmationTitle = title
            self.confirmationMessage = message
            self.confirmationSymbol = image
            self.confirmationCompletionHandler = completionHandler
            self.presentConfirmation = true
        }
    }
    
    func completeConfirmation(userDidApprove: Bool) {
        
        DispatchQueue.main.async {
            self.presentConfirmation = false
        }

        // When these resets aren't in a slight delay the confirmation jumps a little bit when dismissed
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.confirmationTitle = ""
            self.confirmationMessage = ""
            self.confirmationSymbol = ""
        }

        if let completionHandler = self.confirmationCompletionHandler {
            completionHandler(userDidApprove)
            self.confirmationCompletionHandler = nil
        }
    }
}
