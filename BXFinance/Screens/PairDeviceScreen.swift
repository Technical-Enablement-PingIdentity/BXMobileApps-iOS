//
//  PairDeviceView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/18/24.
//

import SwiftUI

struct PairDeviceScreen: View {
    
    @State private var pairingClientReady = false
    @State private var pairingClientInitializationError = false
    @State private var devicePairingClient: DevicePairingClient? = nil
    
    @EnvironmentObject var model: GlobalViewModel
    
    func pairingClientReady(successful: Bool) {
        if successful {
            self.pairingClientReady = true
        } else {
            self.pairingClientInitializationError = true
        }
    }
    
    var body: some View {
        VStack {
            if !pairingClientReady && !pairingClientInitializationError {
                Spacer()
                Text(LocalizedStringKey("loading"))
                ProgressView()
                Spacer()
            }
            
            if pairingClientInitializationError {
                Text(LocalizedStringKey("pairing.initialization_error"))
            }
            
            if pairingClientReady {
                Button(LocalizedStringKey("pairing.pair_device")) {
                    let username = model.getAttributeFromToken(attribute: "sub", type: .accessToken)
                    devicePairingClient?.pairDevice(username: username.isEmpty ? nil : username) { pairingObject in
                        guard let pairingObject else {
                            ToastPresenter.show(style: .error, toast: String(localized: "pairing.error"))
                            print("Error pairing object was nil")
                            return
                        }
                        
                        model.presentUserConfirmation(title: String(localized: "pairing.approve.title"), message: String(localized: "pairing.approve.message"), image: "lock.open.iphone") { userConfirmed in
                            if userConfirmed {
                                pairingObject.approve { response, error in
                                    if let error {
                                        ToastPresenter.show(style: .error, toast: String(localized: "pairing.response_unsuccessful"))
                                        print("An error occured while pairing device: \(error)")
                                    } else {
                                        ToastPresenter.show(style: .success, toast: String(localized: "pairing.successful"))
                                    }
                                }
                            } else {
                                ToastPresenter.show(style: .error, toast: String(localized: "pairing.cancelled"))
                            }
                        }
                    }
                }
                .buttonStyle(FinanceButtonStyle())
            }

        }
        .onAppear {
            let client = DevicePairingClient {
                successful in
                if successful {
                    self.pairingClientReady = true
                } else {
                    self.pairingClientInitializationError = true
                }
            }
            
            self.devicePairingClient = client
        }
    }
}

#Preview {
    PairDeviceScreen()
}
