//
//  BXHealthApp.swift
//  BXHealth
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

@main
struct BXHealthApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeScreen(versionColor: .primaryColor, background: Image("Background")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(2.4, contentMode: .fill)
                .opacity(0.8)
            )
        }
    }
}
