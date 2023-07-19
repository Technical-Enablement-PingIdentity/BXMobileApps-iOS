//
//  PairDeviceModel.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/14/23.
//

import Foundation
import PingOneSDK

class AddDeviceViewModel: ObservableObject {
    
    static let shared = AddDeviceViewModel()
    
    @Published var pairingObject: PairingObject? = nil
    @Published var displayPairedNotificationAlert: Bool = false
    @Published var displayApprovePairingAlert: Bool = false
    @Published var displayPairingError: Bool = false
    
    func needsPairingApproval(pairingObject: PairingObject?) {
        guard let pairingObject else {
            print("Pairing object was nil, nothing to do")
            return
        }
        
        self.pairingObject = pairingObject
        displayApprovePairingAlert = true
    }
    
    func approvalComplete(approved: Bool) {
        displayApprovePairingAlert = false
        pairingObject = nil
        
        if approved {
            displayPairedNotificationAlert = true
        }
    }
}
