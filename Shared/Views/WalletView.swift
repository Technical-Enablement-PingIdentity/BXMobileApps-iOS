//
//  WalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import SwiftUI

struct WalletView: View {
    @ObservedObject private var model: WalletViewModel
    
    init() {
        model = WalletViewModel.shared
        model.refreshCredentials()
    }
    
    var body: some View {
        
        if model.walletInitialized {
            if model.credentials.isEmpty && !model.pairing {
                BXButton(text: "Pair Wallet".localizedForApp()) {
                    model.presentQrScanner = true
                }
                .popover(isPresented: $model.presentQrScanner) {
                    ZStack(alignment: .bottom) {
                        QRScanner(result: $model.scanResult)
                            .onChange(of: model.scanResult) { value in
                                if value != nil {
                                    print("URL Found: \(value!)") // TODO - do something
                                    model.processPairingQrCode()
                                }
                            }
                        
                        Text("Scan your pairing QR Code".localizedForApp())
                            .padding()
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .padding(.bottom)
                    }
                }
            } else if model.pairing {
                Text("Pairing your wallet and issuing your rewards credential. It may take a few minutes for it to appear.".localizedForApp())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
            } else {
                ScrollView {
                    ForEach(model.credentials, id: \.id) {
                        if let uiImage = UIImage.fromClaim($0.claim, size: nil) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal)
                        } else {
                            Text("Error loading credential image".localizedForApp())
                        }
                    }
                }
                
                Spacer()
                
                BXButton(text: "Reset Wallet".localizedForApp()) {
                    model.deleteCredentials()
                }
                .padding(.bottom, 66)
            }
        } else {
            Text("Initializing wallet".localizedForApp())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .font(.system(size: 20))
                .foregroundColor(.white)
            ProgressView()
                .controlSize(.large)
                .tint(.white)
        }

    }
}

#Preview {
    WalletView()
}
