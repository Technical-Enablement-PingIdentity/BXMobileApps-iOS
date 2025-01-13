//
//  AppDelegate.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import AppAuth
import PingOneSDK
import PingOneWallet
import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
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
                    self.handleUserAuthentication(notificationObject: notificationObject)
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
                self.handleUserAuthentication(notificationObject: notificationObject)
            }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        PingOneWalletHelper.initializeWallet()
            .onError { error in
                logerror("Error initializing SDK: \(error.localizedDescription)")
                ApplicationUiHandler().showErrorAlert(title: "Error", message: "Error initializing Wallet, app may behave unexpectedly.", actionTitle: "Okay", actionHandler: nil)
            }
            .onResult { pingOneWalletHelper in
                let coordinator = WalletCoordinator(pingOneWalletHelper: pingOneWalletHelper)
                pingOneWalletHelper.setApplicationUiCallbackHandler(coordinator)
                pingOneWalletHelper.setCredentialPicker(DefaultCredentialPicker(applicationUiCallbackHandler: coordinator))
                WalletViewModel.shared.walletSuccessfullyInitialized(coordinator: coordinator)
                pingOneWalletHelper.processLaunchOptions(launchOptions)
            }
        
        return true
    }
    
    private func handleUserAuthentication(notificationObject: NotificationObject) {
        print(notificationObject)
        GlobalViewModel.shared.presentUserConfirmation(title: K.Strings.Confirmation.Title, message: K.Strings.Confirmation.Message, image: "person.badge.shield.checkmark") { userConfirmed in
            
            if userConfirmed {
                notificationObject.approve(withAuthenticationMethod: "user") { error in
                    if let error {
                        print("An error occurred approving notificationObject \(error.localizedDescription)")
                    } else {
                        print("User approved notification")
                    }
                }
            } else {
                notificationObject.deny { error in
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
