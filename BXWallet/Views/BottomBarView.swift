//
//  BottomBarView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/12/25.
//

import SwiftUI

struct BottomBarView: View {
    
    @Binding var presentSideMenu: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var walletModel: WalletViewModel
    
    private func submissionComplete(verifyResult: String) {
        ToastPresenter.show(style: .success, toast: verifyResult)
    }
    
    private func submissionError(error: String) {
        if error.contains("Invalid URL") {
            ToastPresenter.show(style: .error, toast: String(localized: "verify.invalid_url"))
        } else {
            ToastPresenter.show(style: .error, toast: error)
        }
    }
    
    private func launchQRScanner() {
        walletModel.presentQrScanner = true
    }
    
    var body: some View {
        // Floating QR Scan Button
        VStack(spacing: 0) {
            Spacer()
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    presentSideMenu.toggle()
                }, label: {
                    VStack {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))

                        Text("settings")
                            .font(.system(.caption))

                            
                    }
                })
                .tint(.bxPrimary)
                Spacer()
                Button(action: launchQRScanner) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.bxPrimary))
                        .shadow(radius: 4)
                }
                    .padding(.top)
                    .padding(.bottom, 32)
                Spacer()
                Button(action: {
                    let verifyClient = VerifyClient(submissionCompleteCallback: submissionComplete, submissionErrorCallback: submissionError)
                    
                    verifyClient.launchVerify(primaryColor: .bxPrimary)
                }) {
                    VStack {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                            .font(.system(size: 20))

                        Text("verify")
                            .font(.system(.caption))

                    }
                }
                .tint(.bxPrimary)
                Spacer()
            }
            .background(colorScheme == .light ? .white : .black)
        }
        .ignoresSafeArea()
        .popover(isPresented: $walletModel.presentQrScanner) {
            QRScannerView()
        }
    }
}
