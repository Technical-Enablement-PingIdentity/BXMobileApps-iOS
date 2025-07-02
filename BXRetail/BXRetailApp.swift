//
//  BXRetailApp.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/12/25.
//

import SwiftUI
import PingDavinci

@main
struct BXRetailApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .active {
                        Task {
                            await userViewModel.refreshLoginClient()
                        }
                    }
                }
        }
    }
}
