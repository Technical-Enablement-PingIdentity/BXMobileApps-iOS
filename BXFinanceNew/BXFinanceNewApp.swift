//
//  BXFinanceNewApp.swift
//  BXFinanceNew
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI
import PingOneSignals

@main
struct BXFinanceNewApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var model = GlobalViewModel.shared
    
    init() {
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
                .toastView(toast: $model.toast)
                .overlay(alignment: .bottom) {
                    if model.presentConfirmation {
                        ConfirmationView()
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                    }
                    
                }
                .environmentObject(model)
                .onOpenURL { url in
                    print("We're here")
                    if let authorizationflow = DevicePairingClient.currentAuthorizationFlow {
                        authorizationflow.resumeExternalUserAgentFlow(with: url)
                        DevicePairingClient.currentAuthorizationFlow = nil
                    }
                }
        }
    }
}

