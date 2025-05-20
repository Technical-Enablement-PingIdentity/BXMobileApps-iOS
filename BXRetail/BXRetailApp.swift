//
//  BXRetailApp.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/12/25.
//

import SwiftUI

@main
struct BXRetailApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserViewModel())
        }
    }
}
