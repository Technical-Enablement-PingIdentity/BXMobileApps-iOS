//
//   K.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/14/25.
//

import Foundation

struct K {
    struct Colors {
        static let Primary = "AccentColor"
        static let PrimaryLight = "AccentColorLight"
    }
    
    struct Assets {
        static let LogoWhite = "LogoWhite"
        static let Logo = "BXRetailLogo"
    }
    
    struct DaVinci {
        static let useQaSettingKey = "use_qa_environment"
        
        static let qaClientId = "688fec80-fc99-440b-bd22-4d8d8532103d"
        static let qaIssuer = "https://auth.pingone.com/13d707b7-4df9-47fa-a198-bfa32005ba93/as/.well-known/openid-configuration"
        
        static let productionClientId = "3bcf850a-e29d-47ba-9d71-d13db2262b15"
        static let productionIssuer = "https://auth.pingone.com/94897424-28fc-428e-8cea-1889e93a28bc/as/.well-known/openid-configuration"
        
        static let scopes = ["openid", "address", "email", "phone", "profile"]
        static let redirectUri = "com.pingIdentity.p14c.bxretail.sample://oauth2redirect"
    }
}
