//
//  HomeWalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct HomeWalletView: View {
    
    @Binding var presentSideMenu: Bool
    
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                CredentialListView(credentials: walletModel.credentials, credentialDescriptionAttribute: "email", credentialIssuedAttribute: "issue_date")
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("AppLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                        }
                    }
                    .navigationTitle("credentials")
            }
            BottomBarView(presentSideMenu: $presentSideMenu)
        }
        .fullScreenCover(isPresented: $walletModel.presentCredentialPicker) {
            NavigationStack {
                CredentialListView(credentials: walletModel.matchingCredentials, isSelecting: true, credentialDescriptionAttribute: "email", credentialIssuedAttribute: "issue_date")
                    .navigationTitle("wallet.choose_credential")
            }
        }
    }
    
}

#Preview {
    @Previewable @State var present = false
    HomeWalletView(presentSideMenu: $present)
}

