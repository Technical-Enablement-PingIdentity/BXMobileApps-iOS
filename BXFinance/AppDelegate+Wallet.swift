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

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        PingOneWalletHelper.initializeWallet()
            .onError { error in
                logerror("Error initializing SDK: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    ApplicationUiHandler().showErrorAlert(title: String(localized: "error"), message: String(localized: "wallet.initialization.error"), actionTitle: String(localized: "okay"), actionHandler: nil)
                }
                
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
    
}
