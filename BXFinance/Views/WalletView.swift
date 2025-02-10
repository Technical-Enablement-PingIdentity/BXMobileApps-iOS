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
                Text(LocalizedStringKey("wallet.empty"))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Button(LocalizedStringKey("wallet.configure")){
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
                        Text(LocalizedStringKey("wallet.image_error"))
                    }
                }
            }
            
            Spacer()
            
            Button(LocalizedStringKey("wallet.scan_code")) {
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
