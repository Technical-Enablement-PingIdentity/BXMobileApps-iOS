//
//  BXWalletApp.swift
//  BXWallet
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

@main
struct BXWalletApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var confirmationModel = ConfirmationViewModel.shared
    @StateObject private var walletModel = WalletViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fullScreenCover(isPresented: $confirmationModel.presentConfirmation) {
                    ConfirmationView()
                }
                .onChange(of: walletModel.presentQrScanner) { oldValue, newValue in
                    if !newValue {
                        QRScannerController.shared?.closeCameraSession()
                    }
                }
                .environmentObject(confirmationModel)
                .environmentObject(walletModel)
                .onOpenURL { url in
                    EventObserverUtils.broadcastAppOpenUrlNotification(url.absoluteString)
                }
        }
    }
}
