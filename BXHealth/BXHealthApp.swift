//
//  BXHealthApp.swift
//  BXHealth
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

@main
struct BXHealthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var model = ConfirmationViewModel.shared
    
    init() {
        appDelegate.confirmationModel = ConfirmationViewModel.shared
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeScreen()
                .fullScreenCover(isPresented: $model.presentConfirmation) {
                    ConfirmationView()
                }
                .environmentObject(model)
                .onOpenURL { url in
                    if let authorizationflow = DevicePairingClient.currentAuthorizationFlow {
                        authorizationflow.resumeExternalUserAgentFlow(with: url)
                        DevicePairingClient.currentAuthorizationFlow = nil
                    }
                }
        }
    }
}
