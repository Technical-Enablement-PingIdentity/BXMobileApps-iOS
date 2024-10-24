//
//  AppDelegateWithWallet.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import SwiftUI
import DIDSDK
import PingOneWallet

extension AppDelegate {
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
}
