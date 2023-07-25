//
//  FinanceHomeViewModel.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import Foundation
import PingOneSignals

class FinanceHomeViewModel: ObservableObject, VerifyViewModel {
    
    static let shared = FinanceHomeViewModel()
    
    @Published var displayClientBuilderErrorAlert = false
    @Published var clientBuilderErrorDescription: String? = nil
    
    @Published var displayDocumentSubmissionSuccessfulAlert = false
    @Published var documentSubmissionNameResult: String? = nil
    
    var signalsStatus = "Not Initialized"
}
