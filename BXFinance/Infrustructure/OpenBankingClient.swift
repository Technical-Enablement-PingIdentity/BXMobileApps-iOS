//
//  OpenBankingClient.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import Foundation
import SwiftyJSON

struct OpenBankingClient {
    static func getBalances(accessToken: String) async throws -> [Account] {
        guard let url = URL(string: "\(K.Environment.openBankingBaseUrl)\(K.Environment.openBankingBalancesEndpoint)") else {
            throw OpenBankingClientError(description: "Could not build url")
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let json = try? JSON(data: data) else {
                throw OpenBankingClientError(description: "Could not parse json")
            }
            
            var index = 0
            let accounts = json["Data"]["Balance"].arrayValue.map { account in
                index += 1
                return Account(id: account["AccountId"].int ?? 0, amount: account["Amount"]["Amount"].string ?? "", type: index == 1 ? .checking : index == 2 ? .savings : .creditCard)
            }
            
            return accounts
        } catch {
            throw OpenBankingClientError(description: "Could not complete request to open banking api")
        }
    }
}

struct Account: Identifiable {
    let id: Int
    let amount: String
    let type: AccountType
}

enum AccountType {
    case checking
    case savings
    case creditCard
}

struct OpenBankingClientError: Error {
    let description: String
}
