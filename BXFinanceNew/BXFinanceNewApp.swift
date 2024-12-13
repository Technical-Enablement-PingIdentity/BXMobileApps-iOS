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
    
    @State private var toast: Toast?
    
    @StateObject private var model = GlobalViewModel()
    
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
                .environmentObject(model)
                .alert(model.confirmationTitle, isPresented: $model.displayConfirmation, actions: {
                    Button("Cancel", role: .cancel) {
                        model.completeConfirmation(userDidApprove: false)
                    }
                    Button("Confirm") {
                        model.completeConfirmation(userDidApprove: true)
                    }
                }, message: {
                    Text(model.confirmationMessage)
                })
                .toastView(toast: $model.toast)
        }
    }
}

