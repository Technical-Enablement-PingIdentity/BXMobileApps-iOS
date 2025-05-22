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
        static let clientId = "c96f25c5-926d-4072-a49e-0c2c68547467"
        static let scopes = ["openid", "address", "email", "phone", "profile"]
        static let redirectUri = "com.pingIdentity.p14c.bxretail.sample://oauth2redirect"
        static let discoveryEndpoint = "https://auth.pingone.com/aee45a8e-40c8-4d24-becf-7a0b0063970d/as/.well-known/openid-configuration"
//        static let discoveryEndpoint = "https://demo-bxretail-auth-may-ea.ping-devops.com/as/.well-known/openid-configuration"
    }
}
