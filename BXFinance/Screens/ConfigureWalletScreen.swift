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
    
    var body: some View {
        if walletModel.walletInitialized {
            if walletModel.credentials.isEmpty && !walletModel.pairing {
                Button("Pair Wallet") {
                    walletModel.presentQrScanner = true
                }
                .buttonStyle(FinanceButtonStyle())
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
                            Text("Loading camera. This may take a moment the first time.")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .font(.system(size: 20))
                            ProgressView()
                                .controlSize(.large)
                            Spacer()
                        }
                    } else {
                        Text("Scan your pairing QR Code")
                            .padding()
                            .background(.accent)
                            .foregroundColor(.white)
                            .padding(.bottom)
                    }
                }
                .task {
                    await checkCameraAccess()
                }
            } else if walletModel.pairing {
                Text("Pairing your wallet and issuing your rewards credential. It may take a few minutes for it to appear.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
            } else {
                Spacer()
                Text("Your digital wallet is paired! Navigate to the wallet screen to view your credential.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                Image(systemName: "checkmark.rectangle.stack")      .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(20)
                    .foregroundStyle(Color.white)
                    .background(.accent)
                    .clipShape(Circle())

                Spacer()
                Button("Reset Wallet") {
                    walletModel.deleteCredentials()
                }
                .buttonStyle(FinanceButtonStyle())
                .padding(.bottom, 66)
            }
        } else {
            Text("Initializing wallet")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .font(.system(size: 20))
                .foregroundColor(.white)
            ProgressView()
                .controlSize(.large)
                .tint(.white)
        }

    }
    
    private func checkCameraAccess() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            await AVCaptureDevice.requestAccess(for: .video)
        }
    }
}

#Preview {
    let model = WalletViewModel()

    ConfigureWalletScreen()
        .environmentObject(model)
}
