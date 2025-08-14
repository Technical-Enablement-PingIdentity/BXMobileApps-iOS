//
//  CredentialDetailView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct CredentialDetailView: View {
    let isSelecting: Bool
    let credential: Credential
    let descriptionAttribute: String
    
    @EnvironmentObject var walletModel: WalletViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage = UIImage.fromClaim(credential.rawClaim, size: nil) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical)
            } else {
                Text(LocalizedStringKey("wallet.image_error"))
            }
            
            if isSelecting {
                Text("wallet.choose_attributes")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 8)
                
                ScrollView {
                    VStack(alignment: .leading) {

                        let sortedClaims = credential.claimValues.sorted(by: <).filter { $0.key != "Issued" }
                        
                        let requiredOptions = sortedClaims.filter { walletModel.requestedKeys.contains($0.key) }.map { MultiSelectOption(label: $0.key, value: $0.value) }
                        let optionalOptions = sortedClaims.filter { !walletModel.requestedKeys.contains($0.key) }.map { MultiSelectOption(label: $0.key, value: $0.value) }
                        
                        MultiSelectView(title: String(localized: "wallet.required"), readOnly: true, items: requiredOptions, selectedItems: $walletModel.requestedKeys)
                        
                        MultiSelectView(title: String(localized: "wallet.optional"), items: optionalOptions, selectedItems: $walletModel.optionalKeySelection)
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                Text("wallet.attributes")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 4)
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(credential.claimValues.sorted(by: <), id: \.key) { key, value in
                            Text(key)
                            Text(value)
                                .font(.system(size: 18, weight: .bold))
                                .padding(.bottom, 8)
                                .lineLimit(1)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal)
        .toolbar {
            if !isSelecting {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        walletModel.deleteCredential(credential: credential, credentialDescription: credential.getClaimValue(descriptionAttribute)) { deleted in
                            if deleted {
                                dismiss()
                            }
                        }
                    }) {
                        Image(systemName: "trash")
                    }
                }
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

