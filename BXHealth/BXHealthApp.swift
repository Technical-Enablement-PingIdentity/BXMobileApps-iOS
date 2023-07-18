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
    
    var body: some Scene {
        WindowGroup {
            HealthRootView()
        }
    }
}
