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

}
