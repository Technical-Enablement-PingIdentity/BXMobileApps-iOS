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
    @EnvironmentObject var walletAppModel: WalletAppViewModel
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                CredentialListView(credentials: walletModel.credentials, credentialDescriptionAttribute: walletAppModel.credentialDescriptionKey, credentialIssuedAttribute: walletAppModel.credentialIssueDateKey)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            if walletAppModel.appLogoUrl.isEmpty {
                                Image("AppLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200)
                            } else {
                                AsyncImage(url: URL(string: walletAppModel.appLogoUrl)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image("AppLogo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200)
                                }
                                .scaledToFit()
                                .frame(width: 200)
                            }
                        }
                    }
                    .navigationTitle("credentials")
            }
            .tint(.bxPrimary)
            .padding(.bottom, 80)
            BottomBarView(presentSideMenu: $presentSideMenu)
        }
        .fullScreenCover(isPresented: $walletModel.presentCredentialPicker) {
            NavigationStack {
                CredentialListView(credentials: walletModel.matchingCredentials, isSelecting: true, credentialDescriptionAttribute: walletAppModel.credentialDescriptionKey, credentialIssuedAttribute: walletAppModel.credentialIssueDateKey)
                    .navigationTitle("wallet.choose_credential")
            }
            .tint(.bxPrimary)
        }
    }
    
}

#Preview {
    @Previewable @State var present = false
    HomeWalletView(presentSideMenu: $present)
}

