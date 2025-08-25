//
//  CredentialListView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct CredentialListView: View {
    let credentials: [Credential]
    var isSelecting = false
    
    let credentialDescriptionAttribute: String
    let credentialIssuedAttribute: String
    
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        VStack {
            if credentials.isEmpty {
                Spacer()
                Text("wallet.no_credentials")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List(credentials, id: \.id) { credential in
                    ZStack {
                        CredentialCardView(name: credential.getClaimValue("CardType"), attributes: [credential.getClaimValue(credentialDescriptionAttribute), credential.getClaimValue(credentialIssuedAttribute, formatDate: true)])
                            .overlay {
                                NavigationLink(destination: CredentialDetailView(isSelecting: isSelecting, credential: credential, descriptionAttribute: credentialDescriptionAttribute)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
                .tint(.bxPrimary)
                .listStyle(.plain)
                .toolbarBackground(.hidden, for: .tabBar)
            }
        }
    }
}
