//
//  WalletCoordinator.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import Foundation
import UIKit
import DIDSDK
import PingOneWallet

public class WalletCoordinator {
    
    static let TOAST_DURATION: TimeInterval = 2.0
    
    var pingOneWalletHelper: PingOneWalletHelper
    var applicationUiHandler: ApplicationUiHandler! = ApplicationUiHandler()
    var eventObserver: EventObserver

    private var onCredentialSelected: ((Claim?, [String]) -> Void)? = nil
    
    init(pingOneWalletHelper: PingOneWalletHelper) {
        self.eventObserver = EventObserver()
        self.pingOneWalletHelper = pingOneWalletHelper
        
        self.registerObservers()
    }
    
    private func checkConnectivity() -> Bool {
        return Connectivity.checkNetworkStatus()
    }
    
    private func registerObservers() {
        self.eventObserver.observeNetworkReachability { status in
            if (status == .unavailable) {
                self.showErrorAlert(title: String(localized: "network.error.title"), message: String(localized: "network.error.message"), actionTitle: String(localized: "okay")) {
                    ToastPresenter.show(style: .error, toast: String(localized: "network.toast"))
                }
            }
        }
        self.eventObserver.observeRemoteNotifications { userInfo in
            self.pingOneWalletHelper.processPingOneNotification(userInfo)
        }
        
        self.eventObserver.observePushTokenRegistration { pushToken in
            self.pingOneWalletHelper.updatePushToken(pushToken)
        }
        
        self.eventObserver.observeAppOpenUrl { appOpenUrl in
            self.pingOneWalletHelper.processPingOneRequest(appOpenUrl)
        }
    }
    
    deinit {
        self.eventObserver.removeObservers()
    }
    
    public func showPicker(_ claims: [Claim], _ requestedKeys: [String], onItemPicked: @escaping ((Claim?, [String]) -> Void)) {
        self.onCredentialSelected = onItemPicked
        DispatchQueue.main.async {
            WalletViewModel.shared.presentCredentialPicker(matchingClaims: claims, requestedKeys: requestedKeys)
        }
    }
    
    public func credentialSelected(claim: Claim?, selectedKeys: [String]) {
        if let onSelected = self.onCredentialSelected {
            onSelected(claim, selectedKeys)
            onCredentialSelected = nil
        }
    }
    
    public func processPairingUrl(qrContent: String) {
        print("Process Request \(qrContent)")
        pingOneWalletHelper.processPingOneRequest(qrContent)
    }
}

extension WalletCoordinator: ApplicationUiCallbackHandler {
    
    public func showConfirmationAlert(title: String, message: String, positiveActionTitle: String, cancelActionTitle: String, actionHandler: @escaping (Bool) -> Void) {
        self.applicationUiHandler.showConfirmationAlert(title: title, message: message, positiveActionTitle: positiveActionTitle, cancelActionTitle: cancelActionTitle, actionHandler: actionHandler)
    }
    
    public func showErrorAlert(title: String, message: String, actionTitle: String?, actionHandler: (() -> Void)?) {
        self.applicationUiHandler.showErrorAlert(title: title, message: message, actionTitle: actionTitle, actionHandler: actionHandler)
    }
    
    public func selectCredentialForPresentation(_ credentials: [Claim], requestedKeys: [String], onItemPicked: @escaping ((Claim?, [String]) -> Void)) {
        let claims = credentials.filter { $0.getData()[ClaimKeys.cardType] != nil }
        self.showPicker(claims, requestedKeys, onItemPicked: onItemPicked)
    }
    
    public func openUrl(url: String, onComplete: @escaping (Bool, String) -> Void) {
        self.applicationUiHandler.openUrl(url: url, onComplete: onComplete)
    }
}
