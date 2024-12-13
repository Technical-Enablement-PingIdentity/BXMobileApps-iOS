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
        }
        .padding()

    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(RouterViewModel())
        .environmentObject(GlobalViewModel.preview)
}
