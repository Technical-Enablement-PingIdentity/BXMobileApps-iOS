//
//  WalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import SwiftUI
import AVFoundation

struct WalletView: View {
    @ObservedObject private var model: WalletViewModel
    
    init() {
        model = WalletViewModel.shared
        model.refreshCredentials()
    }
    
    var body: some View {
        VStack {
            if model.walletInitialized {
                if model.credentials.isEmpty && !model.pairing {
                    BXButton(text: "Pair Wallet".localizedForApp()) {
                        model.presentQrScanner = true
                    }
                    .popover(isPresented: $model.presentQrScanner) {
                        ZStack(alignment: .bottom) {
                            QRScanner(result: $model.scanResult, loadingCamera: $model.loadingCamera)
                                .onChange(of: model.scanResult) { value in
                                    if value != nil {
                                        model.processQrCode(true)
                                    }
                                }
                            if (model.loadingCamera) {
                                VStack {
                                    Spacer()
                                    Text("Loading camera. This may take a moment the first time.".localizedForApp())
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 16)
                                        .font(.system(size: 20))
                                    ProgressView()
                                        .controlSize(.large)
                                    Spacer()
                                }
                            } else {
                                Text("Scan your pairing QR Code".localizedForApp())
                                    .padding()
                                    .background(Color.primaryColor)
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                        }
                    }
                    .task {
                        await checkCameraAccess()
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
                    
                    BXButton(text: "Scan Verification QR Code".localizedForApp()) {
                        model.presentQrScanner = true
                    }
                    .popover(isPresented: $model.presentQrScanner) {
                        ZStack(alignment: .bottom) {
                            QRScanner(result: $model.scanResult, loadingCamera: $model.loadingCamera)
                                .onChange(of: model.scanResult) { value in
                                    if value != nil {
                                        model.processQrCode(false)
                                    }
                                }
                            
                            if (model.loadingCamera) {
                                VStack {
                                    Spacer()
                                    Text("Loading camera. This may take a moment the first time.".localizedForApp())
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 16)
                                        .font(.system(size: 20))
                                    ProgressView()
                                        .controlSize(.large)
                                    Spacer()
                                }
                            } else {
                                Text("Scan your verification QR Code".localizedForApp())
                                    .padding()
                                    .background(Color.primaryColor)
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                        }
                    }
                    
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
        .onChange(of: model.presentQrScanner) { value in
            if !value {
                QRScannerController.shared?.closeCameraSession()
            }
        }
    }
}

#Preview {
    WalletView()
}

extension WalletView {
    func checkCameraAccess() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            await AVCaptureDevice.requestAccess(for: .video)
        }
    }
}
