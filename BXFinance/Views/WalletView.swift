//
//  WalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI

struct WalletView: View {
    
    @EnvironmentObject var router: RouterViewModel
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        if walletModel.credentials.isEmpty {
            VStack(spacing: 16) {
                Text("No credentials in wallet, please configure from the profile screen or tap the button below to set up your wallet. If you just completed pairing it may take a few minutes for credentials to be issued.")
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Button("Configure Wallet"){
                    router.navigateTo(.wallet)
                }
                .tint(Color(K.Colors.Primary))
            }
        } else {
            ScrollView {
                ForEach(walletModel.credentials, id: \.id) {
                    if let uiImage = UIImage.fromClaim($0.claim, size: nil) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal)
                    } else {
                        Text("Error loading credential image")
                    }
                }
            }
            
            Spacer()
            
            Button("Scan Verification QR Code") {
                walletModel.presentQrScanner = true
            }
            .buttonStyle(FinanceButtonStyle())
            .padding(.bottom, 66)
            .popover(isPresented: $walletModel.presentQrScanner) {
                ZStack(alignment: .bottom) {
                    QRScanner(result: $walletModel.scanResult, loadingCamera: $walletModel.loadingCamera)
                        .onChange(of: walletModel.scanResult) { oldValue, newValue in
                            if newValue != nil {
                                walletModel.processQrCode(false)
                            }
                        }
                    
                    if (walletModel.loadingCamera) {
                        VStack {
                            Spacer()
                            Text("Loading camera. This may take a moment the first time.")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .font(.system(size: 20))
                            ProgressView()
                                .controlSize(.large)
                            Spacer()
                        }
                    } else {
                        Text("Scan your verification QR Code")
                            .padding()
                            .background(.accent)
                            .foregroundColor(.white)
                            .padding(.bottom, 66)
                    }
                }
            }
        }
    }
}

#Preview {
    WalletView()
        .environmentObject(RouterViewModel())
}
