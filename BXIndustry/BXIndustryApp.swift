//
//  BXIndustryApp.swift
//  BXIndustry
//
//  Created by Eric Anderson on 9/4/24.
//

import SwiftUI
import PingOneSignals

@main
struct BXIndustryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            BXIndustryRootView()
        }
    }
}
