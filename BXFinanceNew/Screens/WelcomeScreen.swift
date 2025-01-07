//
//  WelcomeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/11/24.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @EnvironmentObject private var globalModel: GlobalViewModel
    
    @EnvironmentObject private var router: RouterViewModel

    var body: some View {
        VStack {
            Spacer()
            LogoView(size: .large)
            Text(K.Strings.Login.Welcome)
                .font(.system(size: 28))
            Spacer()
            
            Button(K.Strings.Login.Login) {
                router.navigateTo(.login)
            }
            .buttonStyle(FinanceFullWidthButtonStyle())
            .padding(.bottom, 16)
            
            Button("Continue without Signing In") {
                router.navigateTo(.dashboard)
            }.tint(Color(K.Colors.Primary))
            
            Button("Test Alert") {
                globalModel.presentUserConfirmation(title: "Approve Sign In?", message: "You're trying to login, would you like to approve this login request?") { userApproved in
                    print("Confirmed \(userApproved ? "yes" : "no")")
                }
            }
        }
        .padding()

    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(RouterViewModel())
        .environmentObject(GlobalViewModel.preview)
}
