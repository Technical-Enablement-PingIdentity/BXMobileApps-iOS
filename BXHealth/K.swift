//
//  Constants.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/14/23.
//

import Foundation

struct K {
    struct Colors {
        static let Primary = "AccentColor"
    }
    
    struct Assets {
        static let Logo = "BXHealthLogo"
    }
    
    struct PingOne {
        static let issuer = "https://auth.pingone.com/6a96ada1-d5a2-40db-945d-9398dc873a84/as"
        static let clientId = "a9623025-8595-45ef-8acf-f83226cfbf5a"
        static let redirectUri = "pingonesdk://sample"
    }
    
    struct Oidc {
        static let MobilePayload = "mobilePayload"
        static let Prompt = "prompt"
        static let LoginPrompt = "login"
        static let LoginHint = "login_hint"
    }
}
