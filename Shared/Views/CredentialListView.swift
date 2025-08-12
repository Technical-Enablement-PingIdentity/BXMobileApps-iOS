//
//  CredentialListView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct CredentialListView: View {
    let isSharing: Bool
    
    let titleAttribute: String
    let subtitleAttributes: [String]
    
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        NavigationView {
            let credentials = isSharing ? walletModel.matchingCredentials : walletModel.credentials
            List(credentials, id: \.id) { credential in
                NavigationLink(destination: CredentialDetailView(isSelecting: isSharing, credential: credential)) {
                    VStack(alignment: .leading) {
                        Text(credential.claimValues[titleAttribute] ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .lineLimit(1)
                        
                        ForEach(subtitleAttributes, id: \.self) {
                            Text("\($0): \(credential.claimValues[$0] ?? "")")
                        }
                    }
                }
                .swipeActions {
                    Button("delete", systemImage: "trash") {
                        walletModel.deleteCredential(credential: credential, credentialDescription: credential.claimValues[titleAttribute] ?? "")
                    }.tint(.red)
                }
            }
        }
    }
}
