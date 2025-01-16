//
//  PingFedAuthNClient.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/30/24.
//

import SwiftUI
import SwiftyJSON

final class PingFedAuthnClient {

    private let appUrl: String

    private var flowId: String?

    public var storedUsername: String?
    public var currentStatus: String?
    public var accessToken: String?
    public var idToken: String?
    public var expiresIn: String?

    public var nonce = ""

    init(appUrl: String) {
        self.appUrl = appUrl
    }

    func logout() async throws {
        guard let url = URL(string: "\(appUrl)/idp/startSLO.ping") else {
            throw PingFedNetworkError(
                description: "Could not logout, invalid URL")
        }

        do {
            let request = URLRequest(url: url)

            let (data, _) = try await URLSession.shared.data(for: request)

            if !String(decoding: data, as: UTF8.self).contains(
                "Sign Off Successful")
            {
                throw PingFedNetworkError(
                    description: "Could not logout, unexpected response")
            }
        } catch {
            throw PingFedNetworkError(description: "Could not logout, \(error)")
        }
    }

    func startAuthn() async throws {
        // Set a new nonce for authn flow
        nonce = String.random(length: 24)

        guard
            let url = URL(
                string:
                    "\(appUrl)\(K.PingFed.authnEndpoint)?client_id=\(K.Environment.loginClientId)&response_type=\(K.PingFed.responseType)&response_mode=\(K.PingFed.responseMode)&scope=\(K.PingFed.scopes)&nonce=\(nonce)"
            )
        else {
            throw PingFedNetworkError(
                description:
                    "Could not start Authentication session, invalid URL")
        }

        do {
            let request = URLRequest(url: url)

            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))

            if let json = try? JSON(data: data) {
                if let id = json["id"].string {
                    flowId = id
                }

                if let status = json["status"].string {
                    currentStatus = status
                }

                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }

                print(
                    "Successfully started Authentication session flowId: \(flowId ?? "nil"), status: \(currentStatus ?? "nil")"
                )
            }
        } catch {
            throw PingFedNetworkError(
                description:
                    "An error occurred starting authentication session: \(error.localizedDescription)"
            )
        }
    }

    func submitIdentifier(id: String) async throws {
        do {
            if let json = try await submitStep(
                bodyString: "{\"identifier\": \"\(id)\"}",
                contentType: K.PingFed.Headers.submitIdentifier)
            {

                if let username = json["username"].string {
                    storedUsername = username
                }

                if let status = json["status"].string {
                    currentStatus = status
                }

                print(
                    "Successfully submitted username, username: \(storedUsername ?? "nil") status: \(currentStatus ?? "nil")"
                )
            }
        } catch {
            throw PingFedNetworkError(
                description:
                    "An error occurred submitting username to ping federate \(error.localizedDescription)"
            )
        }
    }

    func submitPassword(password: String, signalsData: String) async throws
        -> String?
    {
        guard let storedUsername else {
            throw PingFedNetworkError(
                description:
                    "No stored username, make sure you have submitted an username first"
            )
        }

        do {
            if let json = try await submitStep(
                bodyString:
                    "{\"username\":\"\(storedUsername)\",\"password\":\"\(password)\",\"captchaResponse\":\"\(signalsData)\"}",
                contentType: K.PingFed.Headers.submitUsernamePassword)
            {

                if let status = json["status"].string {
                    currentStatus = status
                }

                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }

                if json["code"].string == "VALIDATION_ERROR" {
                    return json["details"][0]["userMessage"].string
                }

                print(
                    "Successfully submitted password, username: \(storedUsername) status: \(currentStatus ?? "nil")"
                )
            }
            return nil
        } catch {
            throw PingFedNetworkError(
                description:
                    "An error occurred submitting password to ping federate \(error.localizedDescription)"
            )
        }
    }

    func submitDeviceProfile(signalsData: String) async throws {
        do {
            if let json = try await submitStep(
                bodyString: "{\"signalsSdkDeviceProfile\":\"\(signalsData)\"}",
                contentType: K.PingFed.Headers.submitDeviceProfile)
            {

                if let status = json["status"].string {
                    currentStatus = status
                }

                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }

                print(
                    "Successfully submitted device profile, username: \(storedUsername ?? "nil"), accessToken: \(accessToken ?? "nil")"
                )
            }
        } catch {
            throw PingFedNetworkError(
                description:
                    "An error occurred submitting risk data to ping federate")
        }
    }

    func submitAuthenticate() async throws -> [SelectableDevice] {
        do {
            if let json = try await submitStep(
                bodyString: "{}", contentType: K.PingFed.Headers.authenticate)
            {
                if let status = json["status"].string {
                    currentStatus = status
                }

                var devices: [SelectableDevice] = []

                if currentStatus == "DEVICE_SELECTION_REQUIRED" {
                    if let rawDevices = json["devices"].array {
                        for device in rawDevices {
                            devices.append(try SelectableDevice(device: device))
                        }
                    }
                }

                if currentStatus == "OTP_REQUIRED" {
                    if let selectedDevice = getSelectedDevice(json: json) {
                        devices.append(selectedDevice)
                    }
                }

                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }

                print("Successfully continued authentication")
                return devices
            }

            return []
        } catch {
            throw PingFedNetworkError(
                description: "An error occurred continuing authentication")
        }
    }

    func submitDeviceSelection(deviceId: String) async throws
        -> SelectableDevice?
    {
        do {
            if let json = try await submitStep(
                bodyString: "{\"deviceRef\": {\"id\":\"\(deviceId)\"}}",
                contentType: K.PingFed.Headers.selectDevice)
            {
                if let status = json["status"].string {
                    currentStatus = status
                }

                if currentStatus == "OTP_REQUIRED" {
                    return getSelectedDevice(json: json)
                }
            }

            return nil
        } catch {
            throw PingFedNetworkError(
                description:
                    "An error occurred selecting device for authentication")
        }
    }

    func submitOneTimePasscode(otp: String) async throws -> String? {
        do {
            if let json = try await submitStep(
                bodyString: "{\"otp\":\"\(otp)\"}",
                contentType: K.PingFed.Headers.checkOtp)
            {
                if let status = json["status"].string {
                    currentStatus = status
                }

                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }

                let code = json["code"].string

                if code == "VALIDATION_ERROR" {
                    return json["details"][0]["userMessage"].string
                }

                if code == "REQUEST_FAILED" {
                    currentStatus = "FAILED"
                }

                print(
                    "Successfully submitted one time passcode otp: \(otp) status: \(currentStatus ?? "nil")"
                )
            }

            return nil
        } catch {
            throw PingFedNetworkError(
                description: "An error occurred submitting one time passcode")
        }
    }

    func submitContinueAuthentication() async throws {
        do {
            if let json = try await submitStep(
                bodyString: "{}",
                contentType: K.PingFed.Headers.continueAuthentication)
            {
                if let status = json["status"].string {
                    currentStatus = status
                }

                if currentStatus == "COMPLETED" {
                    try grabTokensFromResponse(json: json)
                }

                print("Successfully continued authentication")
            }
        } catch {
            throw PingFedNetworkError(
                description: "An error occurred continuing authentication")
        }
    }

    private func submitStep(bodyString: String, contentType: String)
        async throws -> JSON?
    {
        guard let flowId else {
            throw PingFedNetworkError(
                description:
                    "flowId was nil, have called startAuthn() to start an authentication session?"
            )
        }

        guard
            let url = URL(
                string: "\(appUrl)\(K.PingFed.authnFlowEndpoint)/\(flowId)")
        else {
            throw PingFedNetworkError(
                description: "Could not build authn flow url")
        }

        // user agent: BXFinance/40 CFNetwork/1568.200.51 Darwin/24.1.0
        do {
            guard let jsonData = bodyString.data(using: .utf8) else {
                throw PingFedNetworkError(
                    description: "Failed to encode json data")
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                K.PingFed.Headers.xsrfValue,
                forHTTPHeaderField: K.PingFed.xsrfHeader)
            request.setValue(
                contentType, forHTTPHeaderField: K.PingFed.contentTypeHeader)
            request.httpBody = jsonData

            let (data, _) = try await URLSession.shared.data(for: request)

            print(String(decoding: data, as: UTF8.self))

            return try? JSON(data: data)
        } catch {
            throw PingFedNetworkError(description: error.localizedDescription)
        }
    }

    private func grabTokensFromResponse(json: JSON) throws {
        if let accessToken = json["authorizeResponse"]["access_token"].string {
            self.accessToken = accessToken
        } else {
            throw PingFedNetworkError(
                description: "Could not find access token in response")
        }

        if let idToken = json["authorizeResponse"]["id_token"].string {
            guard
                JWTUtilities.decode(jwt: idToken)["nonce"] as? String ?? ""
                    == nonce
            else {
                self.nonce = ""
                throw PingFedNetworkError(
                    description: "Nonce doesn't match with id_token")
            }

            self.nonce = ""
            self.idToken = idToken
        }
    }

    private func getSelectedDevice(json: JSON) -> SelectableDevice? {
        do {
            if let selectedDeviceId = json["selectedDeviceRef"]["id"].string,
                let devices = json["devices"].array
            {
                if let rawDevice = devices.first(where: {
                    $0["id"].string == selectedDeviceId
                }) {
                    return try SelectableDevice(device: rawDevice)
                }
            }

            return nil
        } catch {
            return nil
        }
    }
}

struct PingFedNetworkError: LocalizedError {
    let description: String
}

struct SelectableDevice: Identifiable {
    let id: String
    let type: SelectableDeviceType
    let target: String

    init(device: JSON) throws {
        if let jsonId = device["id"].string,
            let jsonType = device["type"].string
        {

            let jsonTarget = device["target"].string

            id = jsonId

            switch jsonType.lowercased() {
            case "email":
                type = .email
                target = jsonTarget ?? "Email Address"
            case "sms":
                type = .sms
                target = jsonTarget ?? "Phone Number"
            case "totp":
                type = .totp
                target = jsonTarget ?? "Authenticator App"
            default:
                type = .hidden
                target = jsonTarget ?? ""
            }

        } else {
            throw PingFedNetworkError(
                description:
                    "Invalid device, id or type is missing, id: (\(device["id"].string ?? "nil")), type: (\(device["type"].string ?? "nil"))"
            )
        }
    }
}

enum SelectableDeviceType {
    case email
    case sms
    case totp
    case hidden
}
