//
//  WalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI

struct WalletView: View {
    
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("No credentials in wallet configure from the profile screen or tap the button below to set up your wallet")
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            Button("Configure Wallet"){
                router.navigateTo(.wallet)
            }
            .tint(Color(K.Colors.Primary))
        }
    }
}

#Preview {
    WalletView()
        .environmentObject(RouterViewModel())
}
