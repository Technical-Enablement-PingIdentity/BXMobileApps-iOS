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
    
    @Published var selectedTab = "home"
    @Published var lastActiveTab = "home"
    
    var signalsStatus = "Not Initialized"
    
    init() {
        self.getEventObserver().observeAppOpenUrl { url in
            if url.contains("/wallet/") {
                self.switchToTab("wallet")
            }
        }
    }
    
    func switchToTab(_ tab: String) {
        
        let activeTabs = ["home", "protect", "wallet", "verify"]
        
        if activeTabs.contains(tab) {
            selectedTab = tab
            lastActiveTab = tab
        } else {
            selectedTab = lastActiveTab
        }
        
    }
    
    private var eventObserver: EventObserver!
    
    private func getEventObserver() -> EventObserver {
        if self.eventObserver == nil {
            self.eventObserver = EventObserver()
        }
        return self.eventObserver
    }
}
