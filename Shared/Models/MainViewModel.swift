//
//  MainViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import Foundation
import PingOneSDK

class MainViewModel: ObservableObject {
    
    static let shared = MainViewModel()
    
    @Published var displayNotificationDeniedWarning = false
    @Published var displayAuthenticationAlert = false
    @Published var currentRoute: Routes = .welcome
     
    var notificationObject: NotificationObject? = nil
    
    func shouldShowNotificationDeniedWarning(displayWarning: Bool) {
        if displayWarning {
            DispatchQueue.main.async {
                self.displayNotificationDeniedWarning = displayWarning
            }
        }
    }
    
    func promptUserForAuthentication(notificationObject: NotificationObject) {
        DispatchQueue.main.async {
            self.notificationObject = notificationObject
            self.displayAuthenticationAlert = true
        }
    }
    
    func finishAuthenticationPrompt(userAccepted: Bool) {
        guard let notificationObject else {
            print("notificationObject is null")
            return;
        }
        
        displayAuthenticationAlert = false
        
        if userAccepted {
            notificationObject.approve(withAuthenticationMethod: "user") { error in
                if let error {
                    print("An error occurred approving notification \(error.localizedDescription)")
                } else {
                    self.notificationObject = nil
                }
            }
        } else {
            notificationObject.deny { error in
                if let error {
                    print("An error occurred denying notification \(error.localizedDescription)")
                } else {
                    self.notificationObject = nil
                }
            }
        }
    }
}

enum Routes {
    case welcome, home
}
