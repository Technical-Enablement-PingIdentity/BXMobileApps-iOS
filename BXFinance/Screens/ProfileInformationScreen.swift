//
//  ProfileInformationScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct ProfileInformationScreen: View {
    
    @EnvironmentObject var globalModel: FinanceGlobalViewModel
    
    var body: some View {
        LogoView(assetName: K.Assets.Logo)
        
        ScrollView {
            ProfileAttributeView(label: LocalizedStringKey("profile.username"), value: globalModel.getAttributeFromToken(attribute: "sub", type: .idToken))
            ProfileAttributeView(label: LocalizedStringKey("profile.first_name"), value: globalModel.getAttributeFromToken(attribute: "first_name", type: .idToken))
            ProfileAttributeView(label: LocalizedStringKey("profile.last_name"), value: globalModel.getAttributeFromToken(attribute: "last_name", type: .idToken))
            ProfileAttributeView(label: LocalizedStringKey("profile.email"), value: globalModel.getAttributeFromToken(attribute: "email", type: .idToken))
        }
        .padding(.horizontal, 16)
        .onAppear {
            GoogleAnalytics.userViewedScreen(screenName: "profile_information_screen")
        }
    }
}

#if DEBUG
struct ProfileInformationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationScreen()
            .environmentObject(FinanceGlobalViewModel.preview)
    }
}
#endif
