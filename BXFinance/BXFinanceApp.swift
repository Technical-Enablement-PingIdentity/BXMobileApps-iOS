//
//  BXFinanceApp.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

@main
struct BXFinanceApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeScreen(versionColor: .white, background: Color.secondaryColor.ignoresSafeArea())
        }
    }
}
