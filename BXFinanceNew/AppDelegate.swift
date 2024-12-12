//
//  AppDelegate.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI
import PingOneSDK
import AppAuth

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
    var currentAuthorizationFlow: OIDExternalUserAgentSession? = nil
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for remote notifications with device token: \(deviceToken)")
        
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(deviceTokenString)")
        
        var deviceTokenType = PingOne.APNSDeviceTokenType.production
        
#if DEBUG
        deviceTokenType = PingOne.APNSDeviceTokenType.sandbox
#endif
        
        PingOne.setDeviceToken(deviceToken, type: deviceTokenType) { error in
            if let error {
                print("Error setting device token in PingOne: \(error.localizedDescription)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification: \(userInfo)")
        
        PingOne.processRemoteNotification(userInfo) { notificationObject, error in
            if let error {
                print("Error processing remote notification \(error.localizedDescription)")
            }
            else if let notificationObject {
                if notificationObject.notificationType == .authentication {
//                    MainViewModel.shared.promptUserForAuthentication(notificationObject: notificationObject)
                    completionHandler(UIBackgroundFetchResult.newData)
                    return
                }
            }
            
            completionHandler(UIBackgroundFetchResult.noData)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            self.currentAuthorizationFlow = nil
            return true
        }

        return false
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did receive user notification")
        
        PingOne.processRemoteNotificationAction(response.actionIdentifier, authenticationMethod: "user", forRemoteNotification: response.notification.request.content.userInfo) { notificationObject, error in
            if let error {
                print("Error processing notification action: \(error.localizedDescription)")
                if error.code == ErrorCode.unrecognizedRemoteNotification.rawValue {
                    // Remote notification may not have been from PingOne
                }
            } else if let notificationObject {
//                MainViewModel.shared.promptUserForAuthentication(notificationObject: notificationObject)
            }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
}
