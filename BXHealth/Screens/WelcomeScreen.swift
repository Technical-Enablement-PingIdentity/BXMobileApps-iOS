//
//  WelcomeScreen.swift
//  BXHealth
//
//  Created by Eric Anderson on 2/11/25.
//

import SwiftUI

struct WelcomeScreen: View {
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                Spacer()
                
                LogoView(assetName: K.Assets.Logo, size: .large)
                Text(LocalizedStringKey("welcome"))
                    .font(.system(size: 28))
                
                Spacer()
                

                Button(LocalizedStringKey("continue")) {
                    navPath.append("dashboard")
                }
                    .padding(.bottom, 8)
                    .buttonStyle(BXButtonStyle())

                
                Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                    .font(.system(size: 12))
                    .padding(.bottom)
            }
            .navigationDestination(for: String.self) { value in
                if value == "dashboard" {
                    DashboardScreen()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }

    }
    
    enum Path {
        case welcome
        case dashboard
    }
}

#Preview {
    WelcomeScreen()
}
