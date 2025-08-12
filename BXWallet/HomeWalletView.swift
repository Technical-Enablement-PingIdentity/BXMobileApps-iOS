//
//  HomeWalletView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct HomeWalletView: View {
    @State private var credentials: [Credential] = [
        Credential(name: "Driver’s License", issuer: "DMV"),
        Credential(name: "Student ID", issuer: "University of Swift")
    ]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    if credentials.isEmpty {
                        Text("No credentials yet")
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                    } else {
                        ForEach(credentials) { credential in
                            CredentialCard(name: credential.name, issuer: credential.issuer)
                                .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 80) // Padding for floating button space
                    
                }
                .padding(.top)
            }
            
            // Floating QR Scan Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: launchQRScanner) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(.accent))
                            .shadow(radius: 4)
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
    
    private func launchQRScanner() {
        ToastPresenter.show(style: .info, toast: String(localized: "verify.invalid_url"))
    }
}

struct HomeWalletView_Previews: PreviewProvider {
    static var previews: some View {
        HomeWalletView()
    }
}
