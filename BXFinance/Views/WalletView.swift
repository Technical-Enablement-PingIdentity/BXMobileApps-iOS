//
//  WalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI

struct WalletView: View {
    
    let credentialTitleAttribute = "Email"
    let credentialSubtitleAttributes = ["Rewards Account #", "Issued"]
    
    @EnvironmentObject var router: RouterViewModel
    @EnvironmentObject var walletModel: WalletViewModel
    
    var body: some View {
        if walletModel.credentials.isEmpty {
            VStack(spacing: 16) {
                Text(LocalizedStringKey("wallet.empty"))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Button(LocalizedStringKey("wallet.configure")){
                    router.navigateTo(.wallet)
                }
                .tint(Color(K.Colors.Primary))
            }
        } else {
            CredentialListView(isSharing: false, titleAttribute: credentialTitleAttribute, subtitleAttributes: credentialSubtitleAttributes)
            
            Button(action: {
                GoogleAnalytics.userTappedButton(buttonName: "scan_credential_verification_qr")
                walletModel.presentQrScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35) // Adjust size as needed
                    .foregroundColor(.white) // Set image color
                    .padding(8)
            }
            .buttonStyle(BXButtonStyle())
            .clipShape(Circle())
            .shadow(radius: 5)
            .padding(.bottom, 24)
            .popover(isPresented: $walletModel.presentCredentialPicker) {
                CredentialListView(isSharing: true, titleAttribute: credentialTitleAttribute, subtitleAttributes: credentialSubtitleAttributes)
            }
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
                            Text(LocalizedStringKey("wallet.camera.loading"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .font(.system(size: 20))
                            ProgressView()
                                .controlSize(.large)
                            Spacer()
                        }
                    } else {
                        Text(LocalizedStringKey("wallet.camera.message"))
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
