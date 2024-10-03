//
//  WalletViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import Foundation

class WalletViewModel: ObservableObject {
    static let shared = WalletViewModel()
    
    @Published var presentQrScanner = false
    @Published var scanResult: String? = nil

}
