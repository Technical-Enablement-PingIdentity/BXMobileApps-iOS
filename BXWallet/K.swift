//
//  K.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct K {
    struct Colors {
        static let Primary = "AccentColor"
        static let BXFinance = Color(red: 0/255, green: 132/255, blue: 95/255)
        static let BXHealth = Color(red: 222/255, green: 95/255, blue: 80/255)
        static let BXRetail = Color(red: 23/255, green: 125/255, blue: 231/255)
        static let MyColorado = Color(red: 0/255, green: 125/255, blue: 48/255)
    }
    
    struct AppStorage {
        static let AppLogoUrl = "APP_LOGO"
        static let PrimaryColor = "PRIMARY_COLOR"
        static let CredentialDescriptionKey = "CREDENTIAL_DESCRIPTION_KEY"
        static let CredentialIssueKey = "CREDENTIAL_ISSUE_KEY"
        static let SelectedTheme = "SELECTED_THEME"
    }
    
    struct Defaults {
        static let CredentialDescriptionKey = "email"
        static let CredentialIssueKey = "issue_date"
    }
}
