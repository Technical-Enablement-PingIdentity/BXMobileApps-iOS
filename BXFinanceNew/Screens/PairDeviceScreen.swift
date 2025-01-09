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
                Text("Loading...")
                ProgressView()
                Spacer()
            }
            
            if pairingClientInitializationError {
                Text("An error occurred initializing pairing client, please contact support.")
            }
            
            if pairingClientReady {
                Button("Pair Device") {
                    let username = model.getAttributeFromToken(attribute: "sub", type: .accessToken)
                    devicePairingClient?.pairDevice(username: username.isEmpty ? nil : username) { pairingObject in
                        guard let pairingObject else {
                            model.showToast(style: .error, message: "An error occurred pairing device. Pairing Object was nil")
                            print("Error pairing object was nil")
                            return
                        }
                        
                        model.presentUserConfirmation(title: "Approve Pairing", message: "Would you like to pair this device with your BXFinance account?", image: "lock.open.iphone") { userConfirmed in
                            if userConfirmed {
                                pairingObject.approve { response, error in
                                    if let error {
                                        model.showToast(style: .error, message: "An error occurred pairing device. Unsuccessful response.")
                                        print("An error occured while pairing device: \(error)")
                                    } else {
                                        model.showToast(style: .success, message: "Device was successfully paired!")
                                    }
                                }
                            } else {
                                model.showToast(style: .error, message: "Device pairing was cancelled.")
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
