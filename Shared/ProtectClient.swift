//
//  BXFinanceApi.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/21/23.
//

import Foundation

struct ProtectClient {
    static func getRiskEvaluation(username: String, riskData: String, apiBaseUrl: String) async throws -> String {
        guard let url = URL(string: "\(apiBaseUrl)/riskEvaluation") else {
            fatalError("Could not initialize url: \(apiBaseUrl)/riskEvaluation")
        }
        
        do {
            let ipAddress = try await getDeviceIpAddress()
            
            guard let jsonData = "{\"username\":\"\(username)\", \"ipAddress\": \"\(ipAddress)\", \"riskPayload\": \"\(riskData)\"}".data(using: .utf8) else {
                fatalError("Could not create risk evaluation body")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
        
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(decoding: jsonData, as: UTF8.self)
            } else {
                // Malformed JSON (this happens in the case of an error)
                return String(decoding: data, as: UTF8.self)
            }
        } catch {
            throw NetworkError(description: "Error retrieving risk assessment: \(error.localizedDescription)")
        }
    }
    
    static func getDeviceIpAddress() async throws -> String {
        guard let url = URL(string: SharedConstants.ipAddressApiUrl) else {
            fatalError("Could not create url from \(SharedConstants.ipAddressApiUrl)")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            return try JSONDecoder().decode(IP.self, from: data).ip
        } catch {
            throw NetworkError(description: "Error retrieving device IP Address: \(error.localizedDescription)")
        }
    }
}

struct IP: Codable {
    let ip: String
}

struct NetworkError: LocalizedError {
    let description: String
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
struct RiskAssessment: Codable {
    let links: Links
    let id: String
    let environment: WelcomeEnvironment
    let createdAt, updatedAt: String
    let event: Event
    let riskPolicySet: RiskPolicySet
    let result: Result
    let details: Details

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case id, environment, createdAt, updatedAt, event, riskPolicySet, result, details
    }
}

// MARK: - Details
struct Details: Codable {
    let ipAddressReputation: IPAddressReputation
    let anonymousNetworkDetected: Bool
    let country: String
    let device: Device
    let state, city: String
    let impossibleTravel: Bool
    let ipVelocityByUser: IPVelocityByUser
    let userLocationAnomaly: User
    let userVelocityByIP: IPVelocityByUser
    let geoVelocity: AnonymousNetwork
    let userRiskBehavior: User
    let ipRisk: AnonymousNetwork
    let userBasedRiskBehavior: User
    let anonymousNetwork: AnonymousNetwork

    enum CodingKeys: String, CodingKey {
        case ipAddressReputation, anonymousNetworkDetected, country, device, state, city, impossibleTravel, ipVelocityByUser, userLocationAnomaly
        case userVelocityByIP = "userVelocityByIp"
        case geoVelocity, userRiskBehavior, ipRisk, userBasedRiskBehavior, anonymousNetwork
    }
}

// MARK: - AnonymousNetwork
struct AnonymousNetwork: Codable {
    let level, type: String
}

// MARK: - Device
struct Device: Codable {
    let id: String
    let os, browser: Browser
}

// MARK: - Browser
struct Browser: Codable {
}

// MARK: - IPAddressReputation
struct IPAddressReputation: Codable {
    let score: Int
    let domain: Domain
    let level: String
}

// MARK: - Domain
struct Domain: Codable {
    let asn: Int
    let sld, tld, organization, isp: String
}

// MARK: - IPVelocityByUser
struct IPVelocityByUser: Codable {
    let level: String
    let threshold: Threshold
    let velocity: Velocity
    let type: String
}

// MARK: - Threshold
struct Threshold: Codable {
    let source: String
}

// MARK: - Velocity
struct Velocity: Codable {
    let distinctCount, during: Int
}

// MARK: - User
struct User: Codable {
    let reason, status, type: String
}

// MARK: - WelcomeEnvironment
struct WelcomeEnvironment: Codable {
    let id: String
}

// MARK: - Event
struct Event: Codable {
    let completionStatus: String
    let targetResource: RiskPolicySet
    let ip: String
    let flow: Flow
    let user: UserClass
    let sharingType, origin, userAgent: String
}

// MARK: - Flow
struct Flow: Codable {
    let type: String
}

// MARK: - RiskPolicySet
struct RiskPolicySet: Codable {
    let id, name: String
}

// MARK: - UserClass
struct UserClass: Codable {
    let id, name, type: String
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, environment, event: EventClass

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case environment, event
    }
}

// MARK: - EventClass
struct EventClass: Codable {
    let href: String
}

// MARK: - Result
struct Result: Codable {
    let level: String
    let score: Int
    let source, type: String
}
