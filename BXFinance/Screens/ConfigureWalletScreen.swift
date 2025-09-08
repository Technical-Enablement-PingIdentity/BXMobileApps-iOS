//
//  WalletScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI
import AVFoundation

struct ConfigureWalletScreen: View {
    
    @EnvironmentObject var walletModel: WalletViewModel
    @EnvironmentObject var router: RouterViewModel
    @EnvironmentObject var globalModel: FinanceGlobalViewModel
    
    private let applicationUiHandler = ApplicationUiHandler()

    var body: some View {
        VStack {
            if walletModel.walletInitialized {
                if walletModel.credentials.isEmpty && !walletModel.pairing {
                    Text(LocalizedStringKey("wallet.pair.message"))
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(LocalizedStringKey("wallet.pair.button")) {
                        GoogleAnalytics.userTappedButton(buttonName: "pair_wallet")
                        Task {
                            await CameraAccess.checkCameraAccess(applicationUiHandler: applicationUiHandler) {
                                walletModel.presentQrScanner = true
                            }
                        }
                    }
                    .buttonStyle(BXButtonStyle())
                    .popover(isPresented: $walletModel.presentQrScanner) {
                        QRScanner(result: $walletModel.scanResult, loadingCamera: $walletModel.loadingCamera)
                            .onChange(of: walletModel.scanResult) { oldValue, newValue in
                                if newValue != nil {
                                    walletModel.processQrCode(true)
                                }
                            }
                        
                        if (walletModel.loadingCamera) {
                            VStack {
                                Spacer()
                                Text(LocalizedStringKey("wallet.loading_camera"))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .font(.system(size: 20))
                                ProgressView()
                                    .controlSize(.large)
                                Spacer()
                            }
                        } else {
                            Text(LocalizedStringKey("wallet.pairing_code"))
                                .padding()
                                .background(.accent)
                                .foregroundColor(.white)
                                .padding(.bottom)
                        }
                    }
                } else if walletModel.pairing {
                    Text(LocalizedStringKey("wallet.pairing_message"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .font(.system(size: 20))
                    ProgressView()
                        .controlSize(.large)
                } else {
                    Spacer()
                    Text(LocalizedStringKey("wallet.paired_message"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    Image(systemName: "checkmark.rectangle.stack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(20)
                        .foregroundStyle(Color.white)
                        .background(.accent)
                        .clipShape(Circle())
                    
                    Spacer()
                    Button(LocalizedStringKey("wallet.reset")) {
                        GoogleAnalytics.userTappedButton(buttonName: "reset_wallet")
                        walletModel.deleteCredentials()
                    }
                    .buttonStyle(BXButtonStyle())
                    .padding(.bottom, 66)
                }
            } else {
                Text(LocalizedStringKey("wallet.initializing"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .font(.system(size: 20))
                ProgressView()
                    .controlSize(.large)
            }
            
        }
        .onAppear {
            GoogleAnalytics.userViewedScreen(screenName: "configure_wallet_screen")
        }
    }
    
}

#Preview {
    let model = WalletViewModel()

    ConfigureWalletScreen()
        .environmentObject(model)
}
