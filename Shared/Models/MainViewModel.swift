//
//  MainViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import Foundation

class MainViewModel: ObservableObject {
    
    static let shared = MainViewModel()
    
    @Published var displayNotificationDeniedWarning = false
    @Published var displayAuthenticationAlert = false
    @Published var currentRoute: Routes = .welcome
    
    func shouldShowNotificationDeniedWarning(displayWarning: Bool) {
        if displayWarning {
            DispatchQueue.main.async {
                self.displayNotificationDeniedWarning = displayWarning
            }
        }
    }
}

enum Routes {
    case welcome, home
}
