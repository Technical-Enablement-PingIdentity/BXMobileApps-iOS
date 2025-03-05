//
//  AppDelegate.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import AppAuth
import PingOneSDK
import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
    var confirmationModel: ConfirmationViewModel?
    
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
                    self.handleUserAuthentication(notificationObject: notificationObject, userInfo: userInfo)
                    completionHandler(UIBackgroundFetchResult.newData)
                    return
                }
            }
            
            completionHandler(UIBackgroundFetchResult.noData)
        }
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
                self.handleUserAuthentication(notificationObject: notificationObject, userInfo: response.notification.request.content.userInfo)
            }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    private func handleUserAuthentication(notificationObject: NotificationObject, userInfo: [AnyHashable : Any]) {
        var title: String? = nil
        var description: String? = nil
        
        if let apsDict = userInfo["aps"] as? NSDictionary {
            if let alert = apsDict["alert"] as? NSDictionary {
                title = alert["title-loc-key"] as? String
                description = (alert["loc-key"] as? String ?? "").components(separatedBy: "[").first
            }
        }
        
        guard let confirmationModel else {
            fatalError("confirmationModel is nil, make sure to set in initialization")
        }
        
        confirmationModel.presentUserConfirmation(title: (title ?? "").isEmpty ? String(localized: "confirmation.title") : title!, message: (description ?? "").isEmpty ? String(localized: "confirmation.message") : description!, image: "person.badge.shield.checkmark") { userConfirmed in
            
            if userConfirmed {
                GoogleAnalytics.userCompletedAction(actionName: "approved_notification", type: title)
                notificationObject.approve(withAuthenticationMethod: "user") { error in
                    if let error {
                        print("An error occurred approving notificationObject \(error.localizedDescription)")
                    } else {
                        print("User approved notification")
                    }
                }
            } else {
                notificationObject.deny { error in
                    GoogleAnalytics.userCompletedAction(actionName: "denied_notification", type: title)
                    if let error {
                        print("An error occurred denying notificationObject \(error.localizedDescription)")
                    } else {
                        print("User denied notification")
                    }
                }
            }
        }
    }
}
