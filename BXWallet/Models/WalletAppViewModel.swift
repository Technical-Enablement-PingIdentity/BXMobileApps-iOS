//
//  WalletAppViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/14/25.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case BXWallet = "BXWallet"
    case BXFinance = "BXFinance"
    case BXHealth = "BXHealth"
    case BXRetail = "BXRetail"
    case MyColorado = "MyColorado"
    case Custom = "Custom"
    
    var id: Self { self }
}

class WalletAppViewModel: ObservableObject {
    
    @Published var appLogoUrl: String
    @Published var primaryColor: Color = .bxPrimary
    @Published var credentialDescriptionKey: String
    @Published var credentialIssueDateKey: String
    @Published var selectedTheme: Theme
    
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
        appLogoUrl = UserDefaults.standard.string(forKey: K.AppStorage.AppLogoUrl) ?? ""
        primaryColor = .bxPrimary
        credentialDescriptionKey = UserDefaults.standard.string(forKey: K.AppStorage.CredentialDescriptionKey) ?? K.Defaults.CredentialDescriptionKey
        credentialIssueDateKey = UserDefaults.standard.string(forKey: K.AppStorage.CredentialIssueKey) ?? K.Defaults.CredentialIssueKey
        selectedTheme = Theme(rawValue: UserDefaults.standard.string(forKey: K.AppStorage.SelectedTheme) ?? "") ?? .BXWallet
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
    
    func updateTheme(theme: Theme) {
        
        if (theme != .BXWallet) {
            UserDefaults.standard.set(theme.rawValue, forKey: K.AppStorage.SelectedTheme)
        } else {
            UserDefaults.standard.removeObject(forKey: K.AppStorage.SelectedTheme)
        }
        
        if theme == .BXFinance || theme == .BXHealth || theme == .BXRetail {
            UIApplication.shared.setAlternateIconName("AppIcon-\(theme.rawValue)") { error in
                if let error {
                    print("Unable to set app icon to AppIcon-\(theme.rawValue): \(error)")
                }
            }
        } else {
            // BXWallet and Custom should revert to default icon
            UIApplication.shared.setAlternateIconName(nil) { error in
                if let error {
                    print("Unable to reset app icon to default: \(error)")
                }
            }
        }
        
        var themeColor: Color
        
        switch theme {
        case .BXFinance:
            themeColor = K.Colors.BXFinance
        case .BXHealth:
            themeColor = K.Colors.BXHealth
        case .BXRetail:
            themeColor = K.Colors.BXRetail
        case .MyColorado:
            themeColor = K.Colors.MyColorado
        case .BXWallet, .Custom:
            themeColor = .accent
        }
        
        primaryColor = themeColor
        updatePrimaryColor(color: themeColor)
        updateAppLogoUrl(url: "")
        
    }
    
    func resetAllSettings() {
        appLogoUrl = ""
        primaryColor = .accent
        credentialDescriptionKey = K.Defaults.CredentialDescriptionKey
        credentialIssueDateKey = K.Defaults.CredentialIssueKey
        
        UserDefaults.standard.removeObject(forKey: K.AppStorage.AppLogoUrl)
        UserDefaults.standard.removeObject(forKey: K.AppStorage.PrimaryColor)
        UserDefaults.standard.removeObject(forKey: K.AppStorage.CredentialDescriptionKey)
        UserDefaults.standard.removeObject(forKey: K.AppStorage.CredentialIssueKey)
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
