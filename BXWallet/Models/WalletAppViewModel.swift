//
//  WalletAppViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/14/25.
//

import SwiftUI

class WalletAppViewModel: ObservableObject {
    
    @Published var appLogoUrl: String
    @Published var primaryColor: Color = .bxPrimary
    @Published var credentialDescriptionKey: String
    @Published var credentialIssueDateKey: String
    
    private let appLogoDebouncer = debounce(delay: 0.25) { (url: String) in
        if url == "" {
            UserDefaults.standard.removeObject(forKey: K.AppStorage.AppLogoUrl)
        } else {
            UserDefaults.standard.set(url, forKey: K.AppStorage.AppLogoUrl)
        }
    }
    
    private let colorDebouncer = debounce(delay: 0.25) { (color: Color) in
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: K.AppStorage.PrimaryColor)
        } catch {
            print("Could not save color \(error.localizedDescription)")
        }
    }
    
    private let credentialDescriptionDebouncer = debounce(delay: 0.25) { (key: String) in
        if key == K.Defaults.CredentialDescriptionKey {
            UserDefaults.standard.removeObject(forKey: K.AppStorage.CredentialDescriptionKey)
        } else {
            UserDefaults.standard.set(key, forKey: K.AppStorage.CredentialDescriptionKey)
        }
    }
    
    private let credentialIssueDateDebouncer = debounce(delay: 0.25) { (key: String) in
        if key == K.Defaults.CredentialIssueKey {
            UserDefaults.standard.removeObject(forKey: K.AppStorage.CredentialIssueKey)
        } else {
            UserDefaults.standard.set(key, forKey: K.AppStorage.CredentialIssueKey)
        }
    }
    
    init() {
        appLogoUrl = UserDefaults.standard.string(forKey: K.AppStorage.AppLogoUrl) ?? "https://bxverifiedob-my-colorado.bxverifiedonboarding.org/candidate/logo.png"
        primaryColor = .bxPrimary
        credentialDescriptionKey = UserDefaults.standard.string(forKey: K.AppStorage.CredentialDescriptionKey) ?? K.Defaults.CredentialDescriptionKey
        credentialIssueDateKey = UserDefaults.standard.string(forKey: K.AppStorage.CredentialIssueKey) ?? K.Defaults.CredentialIssueKey
    }
    
    func updateAppLogoUrl(url: String) {
        appLogoDebouncer(url)
    }
    
    func updatePrimaryColor(color: Color) {
        colorDebouncer(color)
    }
    
    func updateCredentialDescriptionKey(key: String) {
        credentialDescriptionDebouncer(key)
    }
    
    func updateCredentialIssueDateKey(key: String) {
        credentialIssueDateDebouncer(key)
    }
    
    private static func debounce<T>(
        delay: TimeInterval,
        queue: DispatchQueue = .main,
        action: @escaping (T) -> Void
    ) -> (T) -> Void {
        var workItem: DispatchWorkItem?

        return { (param: T) in
            workItem?.cancel()
            let item = DispatchWorkItem { action(param) }
            workItem = item
            queue.asyncAfter(deadline: .now() + delay, execute: item)
        }
    }
    
}
