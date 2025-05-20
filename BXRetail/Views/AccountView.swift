//
//  AccountView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/16/25.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            if userViewModel.isLoggedIn {
                Button("sign_out".resource) {
                    Task {
                        GoogleAnalytics.userTappedButton(buttonName: "sign_out")
                        await userViewModel.logoutUser()
                    }
                    
                }.buttonStyle(BXButtonStyle())
            } else {
                SignInCardView(note: "account.not_signed_in".resource)
            }
        }.padding(.horizontal)
    }
}

#Preview {
    AccountView()
}
