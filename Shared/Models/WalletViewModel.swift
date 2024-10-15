//
//  WalletViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import Foundation
import DIDSDK


class WalletViewModel: ObservableObject {
    static let shared = WalletViewModel()
    
    @Published var presentQrScanner = false
    @Published var scanResult: String? = nil
    
    @Published var walletInitialized = false
    @Published var credentials: [Credential] = []
    
    var coordinator: WalletCoordinator? = nil
    private var eventObserver: EventObserver!
    
    func walletSuccessfullyInitialized(coordinator: WalletCoordinator) {
        walletInitialized = true
        self.coordinator = coordinator
        
        refreshCredentials()
    }
    
    func processPairingQrCode() {
        guard let scanResult else {
            print("scanResult is nil, nothing to process")
            return;
        }
        
        presentQrScanner = false
        coordinator?.processPairingUrl(qrContent: scanResult)
    }
    
    func refreshCredentials() {
        if coordinator != nil {
            DispatchQueue.main.async {
                let claims = self.coordinator!.pingOneWalletHelper.getDataRepository().getAllCredentials()
                self.credentials = claims.map { Credential(claim: $0) }
            }
        }
    }
    
    func observeCredentialUpdates(/*onUpdate: @escaping () -> Void*/) {
        self.getEventObserver().observeCredentialUpdates {
            self.refreshCredentials()
        }
    }
    
    func deleteCredentials() {
        guard let coordinator else {
            print("Coordinator is nil")
            return
        }
        
        self.coordinator?.pingOneWalletHelper.deleteCredentials()
        
        DispatchQueue.main.async {
            self.refreshCredentials()
        }

    }
    
    private func getEventObserver() -> EventObserver {
        if self.eventObserver == nil {
            self.eventObserver = EventObserver()
        }
        return self.eventObserver
    }

}

struct Credential {
    let id = UUID()
    let claim: Claim
}
