//
//  AddDeviceView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var appDelegate: AppDelegate
    
    private let devicePairingClient: DevicePairingClient?
    
    @ObservedObject private var model: AddDeviceViewModel
    
    init(issuer: String, redirectUri: String, clientId: String) {
        model = AddDeviceViewModel.shared
        
        if let issuerUrl = URL(string: issuer),
           let redirectUrl = URL(string: redirectUri) {
            devicePairingClient = DevicePairingClient(issuer: issuerUrl, redirectUri: redirectUrl, clientId: clientId)
        } else {
            devicePairingClient = nil
            print("Unable to parse issuer and/or redirect URIs as URLs, device pairing will not work")
        }
    }
    
    var body: some View {
        BXButton(text: "Add Device".localizedForApp()) {
            guard let rootViewController = UIUtilities.getRootViewController() else {
                print("Unable to get rootViewController, cannot pair a device")
                return
            }
            
            devicePairingClient?.pairDevice(appDelegate: appDelegate, viewController: rootViewController, approvePairingHandler: model.needsPairingApproval)
        }
        .disabled(devicePairingClient == nil || !devicePairingClient!.clientReady == false)
        .alert("Pair Device Title".localizedForApp(), isPresented: $model.displayApprovePairingAlert) {
            Button("Approve".localizedForApp()) {
                guard let pairingObject = model.pairingObject else {
                    fatalError("pairingObject is null")
                }
                
                pairingObject.approve { response, error in
                    if let error {
                        print("Device pairing failed: \(error.localizedDescription)")
                    } else {
                        model.displayPairedNotificationAlert = true
                    }
                }
            }
            Button("Deny".localizedForApp(), role: .destructive) {
                model.approvalComplete(approved: false)
            }
        }
        .alert("Device Paired".localizedForApp(), isPresented: $model.displayPairedNotificationAlert) {
            Button("Okay".localizedForApp()) {
                model.displayPairedNotificationAlert = false
            }
        }
    }
}

