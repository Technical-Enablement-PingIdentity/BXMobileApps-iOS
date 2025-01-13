//
//  ProfileInformationScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct ProfileInformationScreen: View {
    
    @EnvironmentObject var globalModel: GlobalViewModel
    
    var body: some View {
        LogoView()
        
        ScrollView {
            ProfileAttributeView(label: "Username", value: globalModel.getAttributeFromToken(attribute: "sub", type: .idToken))
            ProfileAttributeView(label: "First Name", value: globalModel.getAttributeFromToken(attribute: "first_name", type: .idToken))
            ProfileAttributeView(label: "Last Name", value: globalModel.getAttributeFromToken(attribute: "last_name", type: .idToken))
            ProfileAttributeView(label: "Email", value: globalModel.getAttributeFromToken(attribute: "email", type: .idToken))
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileInformationScreen()
        .environmentObject(GlobalViewModel.preview)
}
