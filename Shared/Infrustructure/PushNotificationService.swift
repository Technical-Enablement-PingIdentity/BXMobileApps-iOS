//
//  PushNotificationService.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 2/11/25.
//

import SwiftUI
import PingOneSDK

struct PushNotificationService {
    static func registerForPushNotifications(completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                // Need to do this either way so the Alert will pop up in the app even if they do not want push notifications.
                if error == nil {
                    center.setNotificationCategories(PingOne.getUNNotificationCategories())
                    DispatchQueue.main.async {
                        print("Registering for remote notifications")
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                
                if !granted {
                    print("User denied permission for push notifications.")
                }
                
                completionHandler(granted)
            }
        }
    }
}
