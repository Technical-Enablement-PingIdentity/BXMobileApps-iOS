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
    @Published var loadingCamera = false
    
    @Published var walletInitialized = false
    @Published var pairing = false
    @Published var credentials: [Credential] = []
    
    var coordinator: WalletCoordinator? = nil
    private var eventObserver: EventObserver!
    
    func walletSuccessfullyInitialized(coordinator: WalletCoordinator) {
        walletInitialized = true
        self.coordinator = coordinator
        
        refreshCredentials()
        observeAppOpenUrl()
        observeCredentialUpdates()
        observeUserCancelledPairingRequest()
    }
    
    func processQrCode(_ isPairing: Bool) {
        guard let scanResult else {
            print("scanResult is nil, nothing to process")
            return;
        }
        
        presentQrScanner = false
        pairing = isPairing
        coordinator?.processPairingUrl(qrContent: scanResult)
        self.scanResult = nil
    }
    
    func refreshCredentials() {
        if coordinator != nil {
            DispatchQueue.main.async {
                let claims = self.coordinator!.pingOneWalletHelper.getDataRepository().getAllCredentials()
                self.credentials = claims.map { Credential(claim: $0) }
                if self.credentials.count > 0 {
                    self.pairing = false
                }
            }
        }
    }
    
    func observeUserCancelledPairingRequest() {
        self.getEventObserver().observeUserCancelledPairing {
            self.pairing = false
        }
    }
    
    func observeCredentialUpdates() {
        self.getEventObserver().observeCredentialUpdates {
            self.refreshCredentials()
        }
    }
    
    func observeAppOpenUrl() {
        self.getEventObserver().observeAppOpenUrl { [self] url in
            if url.contains("/wallet/") {
                guard let coordinator else {
                    print("Wallet not yet initialized, can't pair wallet")
                    return
                }
                
                pairing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    coordinator.processPairingUrl(qrContent: url)
                }
            }
        }
    }
    
    func deleteCredentials() {
        guard let coordinator else {
            print("Coordinator is nil")
            return
        }
        
        coordinator.pingOneWalletHelper.deleteCredentials {
            DispatchQueue.main.async {
                self.refreshCredentials()
            }
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
