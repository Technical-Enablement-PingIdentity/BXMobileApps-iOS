//
//  BXFinanceApp.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI
import PingOneSignals

@main
struct BXFinanceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            FinanceRootView()
        }
    }
}
