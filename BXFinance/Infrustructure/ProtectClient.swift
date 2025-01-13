//
//  ProtectClient.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import Foundation
import SwiftyJSON
import PingOneSignals

struct ProtectClient {
    
    static func getSignalsData() async throws -> String {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String, Error>) in
            guard let signals = PingOneSignals.sharedInstance() else {
                continuation.resume(throwing: PingOneSignalsError(description: "Could not get shared PingOneSignals instance"))
                return
            }
            
            signals.getData { data, error in
                if let error {
                    continuation.resume(throwing: PingOneSignalsError(description: "An error occurred getting signals data \(error.localizedDescription)"))
                    return
                }
                
                guard let data else {
                    continuation.resume(throwing: PingOneSignalsError(description: "Signals data is nil"))
                    return
                }
                
                continuation.resume(returning: data)
            }
        })
    }
    
    static func getRiskEvaluation(username: String) async throws -> String {
        guard let url = URL(string: "\(K.Environment.baseApiUrl)/riskEvaluation") else {
            throw ProtectClientError(description: "Could not create url from \(K.Environment.baseApiUrl)/riskEvaluation")
        }
        
        do {
            let ipAddress = try await getDeviceIpAddress()
            let riskData = try await getSignalsData()
            
            guard let jsonData = "{\"username\":\"\(username)\", \"ipAddress\": \"\(ipAddress)\", \"riskPayload\": \"\(riskData)\"}".data(using: .utf8) else {
                throw ProtectClientError(description: "Could not create risk evaluation body")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
        
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(decoding: jsonData, as: UTF8.self).replacingOccurrences(of: "\\/", with: "/")  
            } else {
                // Malformed JSON (this happens in the case of an error)
                return String(decoding: data, as: UTF8.self)
            }
        } catch {
            throw ProtectClientError(description: "Could not get risk evaluation \(error.localizedDescription)")
        }
    }
    
    static private func getDeviceIpAddress() async throws -> String {
        guard let url = URL(string: K.Environment.ipAddressApiUrl) else {
            fatalError("Could not create url from \(K.Environment.ipAddressApiUrl)")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let data = try? JSON(data: data), let ipAddress = data["ip"].string {
            return ipAddress
        }

        throw ProtectClientError(description: "Could retrieve device ip address")
    }
}

struct ProtectClientError: LocalizedError {
    let description: String
}
