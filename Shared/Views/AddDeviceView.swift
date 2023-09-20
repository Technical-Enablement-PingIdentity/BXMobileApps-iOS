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
        let deviceModel = AddDeviceViewModel.shared
        model = deviceModel
        
        if let issuerUrl = URL(string: issuer),
           let redirectUrl = URL(string: redirectUri) {
            devicePairingClient = DevicePairingClient(issuer: issuerUrl, redirectUri: redirectUrl, clientId: clientId, completionHandler: deviceModel.pairingClientReady)
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
            
            guard let devicePairingClient else {
                print("devicePairingClient is null")
                return
            }
            
            devicePairingClient.pairDevice(appDelegate: appDelegate, viewController: rootViewController, approvePairingHandler: model.needsPairingApproval)
        }
        .disabled(!model.pairingClientReady)
        .alert("Pair Device Title".localizedForApp(), isPresented: $model.displayApprovePairingAlert) {
            Button("Approve".localizedForApp()) {
                guard let pairingObject = model.pairingObject else {
                    fatalError("pairingObject is nil")
                }
                
                pairingObject.approve { response, error in
                    DispatchQueue.main.async {
                        if let error {
                            model.displayPairingError = true
                            model.pairingErrorMessage = error.localizedDescription
                            model.approvalComplete(approved: false)
                        } else {
                            model.approvalComplete(approved: true)
                        }
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
        .alert(model.pairingErrorMessage ?? "Error Pairing Device".localizedForApp(), isPresented: $model.displayPairingError, actions: {
            Button("Okay".localizedForApp()) {
                model.displayPairingError = false
                model.pairingErrorMessage = nil
            }
        })
    }
}

