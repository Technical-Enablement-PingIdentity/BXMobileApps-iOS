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
    }
    
    var body: some View {
        BXButton(text: "Pair Wallet".localizedForApp()) {
            model.presentQrScanner = true
        }
        .popover(isPresented: $model.presentQrScanner) {
            ZStack(alignment: .bottom) {
                QRScanner(result: $model.scanResult)
                    .onChange(of: model.scanResult) { value in
                        if value != nil {
                            model.presentQrScanner = false
                            print("URL Found: \(value!)") // TODO - do something
                        }
                    }
                
                Text("No QR code detected".localizedForApp())
                    .padding()
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    WalletView()
}
