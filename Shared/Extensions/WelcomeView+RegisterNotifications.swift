//
//  App.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI
import PingOneSDK

extension WelcomeView {
    // Completion Handler should be sent whether or not to display an alert to the user, only do this if they deny permission, and only when they are prompted (not when they open the app in the future)
    func registerNotifications(completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    // Need to do this either way so the Alert will pop up in the app even if they do not want push notifications.
                    if error == nil {
                        center.setNotificationCategories(PingOne.getUNNotificationCategories())
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    
                    if !granted {
                        print("User denied permission for push notifications.")
                    }
                    
                    completionHandler(!granted)
                }
            } else {
                completionHandler(false)
            }
        }
    }
}

