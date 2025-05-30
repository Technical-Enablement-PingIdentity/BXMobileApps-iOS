//
//  BXFinanceApp.swift
//  BXFinance
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI
import PingOneSignals

@main
struct BXFinanceApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var confirmationModel = ConfirmationViewModel.shared
    @StateObject private var walletModel = WalletViewModel.shared
    @StateObject private var financeModel = FinanceGlobalViewModel.shared
    
    init() {
        appDelegate.confirmationModel = ConfirmationViewModel.shared
        
        // Initialize PingOneSignals SDK
        let initParams = POInitParams()
        initParams.envId = K.PingOne.pingOneEnvId
            
        let pingOneSignals = PingOneSignals.initSDK(initParams: initParams)
        
        pingOneSignals.setInitCallback { error in
            if let error {
                print("PingOne Signals init failed: \(error.localizedDescription)")
            } else {
                print("PingOne Signals initialized!")
            }
        }
    }

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
                .environmentObject(financeModel)
                .onOpenURL { url in
                    if let authorizationflow = DevicePairingClient.currentAuthorizationFlow {
                        authorizationflow.resumeExternalUserAgentFlow(with: url)
                        DevicePairingClient.currentAuthorizationFlow = nil
                    }
                    
                    EventObserverUtils.broadcastAppOpenUrlNotification(url.absoluteString)
                }
        }
    }
}

