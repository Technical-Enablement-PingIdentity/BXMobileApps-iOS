//
//  ContentView.swift
//  BXWallet
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct ContentView: View {
    
    func submissionComplete(verifyResult: String) {
        ToastPresenter.show(style: .success, toast: verifyResult)
    }
    
    func submissionError(error: String) {
        if error.contains("Invalid URL") {
            ToastPresenter.show(style: .error, toast: String(localized: "verify.invalid_url"))
        } else {
            ToastPresenter.show(style: .error, toast: error)
        }
    }
    
    var body: some View {
        NavigationStack {
            HomeWalletView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Action for menu button
                        }, label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.gray)
                        })
                    }
                    ToolbarItem(placement: .principal) {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            let verifyClient = VerifyClient(submissionCompleteCallback: submissionComplete, submissionErrorCallback: submissionError)
                            
                            verifyClient.launchVerify()
                        }) {
                            VStack {
                                Image(systemName: "person.badge.shield.checkmark.fill")
                                Text("Verify")
                                    .font(.system(.caption))
                            }
                        }
                    }
                }
                .navigationTitle("Credentials")
        }
    }
}

#Preview {
    ContentView()
}
