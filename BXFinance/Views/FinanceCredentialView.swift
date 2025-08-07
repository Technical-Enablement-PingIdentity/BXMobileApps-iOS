//
//  FinanceCredentialView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/6/25.
//

import SwiftUI

struct FinanceCredentialListView: View {
    let isSelecting: Bool
    
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        NavigationView {
            let credentials = isSelecting ? walletModel.matchingCredentials : walletModel.credentials
            List(credentials, id: \.id) { credential in
                NavigationLink(destination: FinanceCredentialDetailView(isSelecting: isSelecting, credential: credential)) {
                    VStack(alignment: .leading) {
                        Text(credential.claimValues["Email"] ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .lineLimit(1)
                        
                        Text("Rewards Account: #\(credential.claimValues["Rewards Account #"] ?? "")")
                        Text("Issued: \(DateUtils.getFormattedDateFromClaimValue(date: credential.claimValues["Issued"] ?? ""))")
                    }
                }
                .swipeActions {
                    Button("delete", systemImage: "trash") {
                        walletModel.deleteCredential(credential: credential, credentialDescription: credential.claimValues["Email"] ?? "")
                    }
                        .tint(.red)
                }
            }
        }
    }
}


struct FinanceCredentialDetailView: View {
    let isSelecting: Bool
    let credential: Credential
    
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let uiImage = UIImage.fromClaim(credential.rawClaim, size: nil) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    Text(LocalizedStringKey("wallet.image_error"))
                }
                
                if isSelecting {
                    MultiSelectForm(items: walletModel.requestedKeys, title: "Select Attributes to Share", selectedItems: $walletModel.requestedKeysSelection)
                        .padding(.bottom)
                }
                
                VStack(alignment: .leading) {
                    Text("wallet.attributes")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 4)
                    
                    ForEach(credential.claimValues.sorted(by: <), id: \.key) { key, value in
                        Text("\(key): \(value)")
                    }
                }
                .padding(.horizontal)
            }
        }
        
        if isSelecting {
            Button("wallet.send_credential") {
                walletModel.credentialSelected(credential: credential)
            }
            .buttonStyle(BXButtonStyle())
            .padding(.bottom)
        }
    }
}
