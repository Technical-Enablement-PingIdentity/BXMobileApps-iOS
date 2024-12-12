//
//  K.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

struct K {
    struct Colors {
        static let Primary = "PrimaryColor"
    }
    
    struct Strings {
        struct Shared {
            static let Back = "Back"
            static let Submit = "Submit"
        }
        
        struct Login {
            static let Welcome = "Welcome!"
            static let Login = "Login"
            static let Username = "Username"
            static let Password = "Password"
            static let Submit = "Submit"
        }
    }
    
    struct Oidc {
        static let MobilePayload = "mobilePayload"
        static let Prompt = "prompt"
        static let LoginPrompt = "login"
    }
    
    struct PingOne {
        static let issuer = "https://auth.pingone.com/17161047-290f-4c88-b771-01adc4e81564/as"
        static let clientId = "028887be-5d57-4cb8-aeb9-874c4f202ae0"
        static let redirectUri = "pingonesdk://sample"
        static let pingOneEnvId = "6c77a243-4622-4c89-a0ca-5905fb4eb3f4"
        static let apiBaseUrl = "https://api.bxfinance.org"
    }
    
    struct PingFed {
        static let authnEndpoint = "/as/authorization.oauth2"
        static let authnFlowEndpoint = "/pf-ws/authn/flows"
        static let responseType = "token id_token"
        static let responseMode = "pi.flow"
        static let contentTypeHeader = "Content-Type"
        static let xsrfHeader = "X-XSRF-Header"
        
        struct Headers {
            static let xsrfValue = "PingFederate"
            static let submitIdentifier = "application/vnd.pingidentity.submitIdentifier+json"
            static let submitUsernamePassword = "application/vnd.pingidentity.checkUsernamePassword+json"
            static let submitDeviceProfile = "application/vnd.pingidentity.submitDeviceProfile+json"
        }
    }
    
    struct Environment {
        static let baseUrl = "https://bxfinance-dec-ea.ping-devops.com"
        static let loginClientId = "bxFinanceMobile"
        static let openBankingBaseUrl = "https://openbanking-qa.ping-devops.com"
        static let openBankingBalancesEndpoint = "/OpenBanking/v2/balances"
    }
}
