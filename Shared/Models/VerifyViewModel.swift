//
//  VerifyViewModel.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import Foundation

protocol VerifyViewModel {
    var displayClientBuilderErrorAlert: Bool { get set }
    var clientBuilderErrorDescription: String? { get set }
    
    var displayDocumentSubmissionSuccessfulAlert: Bool { get set }
    var documentSubmissionNameResult: String? { get set }
}
