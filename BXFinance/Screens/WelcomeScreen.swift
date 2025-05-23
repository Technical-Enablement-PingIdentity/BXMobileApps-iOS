//
//  WelcomeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/11/24.
//

import SwiftUI
import PingOneSDK

struct WelcomeScreen: View {
    
    @EnvironmentObject private var globalModel: FinanceGlobalViewModel
    
    @EnvironmentObject private var router: RouterViewModel

    var body: some View {
        VStack {
            Spacer()
            LogoView(assetName: K.Assets.Logo, size: .large)
            Text(LocalizedStringKey("welcome"))
                .font(.system(size: 28))
            Spacer()
            
            Button(LocalizedStringKey("sign_in")) {
                GoogleAnalytics.userTappedButton(buttonName: "sign_in")
                router.navigateTo(.login)
            }
            .buttonStyle(BXFullWidthButtonStyle())
            .padding(.bottom, 16)
            
            Button(LocalizedStringKey("skip_sign_in")) {
                GoogleAnalytics.userTappedButton(buttonName: "skip_sign_in")
                router.navigateTo(.dashboard)
            }
            .tint(Color(K.Colors.Primary))
            .padding(.bottom, 8)
            
            Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                .font(.system(size: 12))
        }
        .padding()
        .onAppear {
            GoogleAnalytics.userViewedScreen(screenName: "welcome_screen")
        }
    }
}

#if DEBUG
struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .environmentObject(RouterViewModel())
            .environmentObject(FinanceGlobalViewModel.preview)
    }
}
#endif
