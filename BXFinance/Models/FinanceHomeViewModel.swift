//
//  FinanceHomeViewModel.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import Foundation

class FinanceHomeViewModel: ObservableObject, VerifyViewModel {
    
    static let shared = FinanceHomeViewModel()
    
    @Published var displayClientBuilderErrorAlert: Bool = false
    @Published var clientBuilderErrorDescription: String? = nil
    
    @Published var displayDocumentSubmissionSuccessfulAlert: Bool = false
    @Published var documentSubmissionNameResult: String? = nil
    
}
