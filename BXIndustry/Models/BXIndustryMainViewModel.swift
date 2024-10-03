//
//  BXIndustryMainViewModel.swift
//  BXIndustry
//
//  Created by Eric Anderson on 9/12/24.
//

import SwiftUI

class BXIndustryMainViewModel : ObservableObject {
    
    static let shared = BXIndustryMainViewModel()
    
    private let SELECTED_VERTICAL_KEY: String = "selectedVertical"
    private let USER_HAS_SET_VERTICAL = "userHasSetVertical"
    
    private let ENABLE_PAIRING_TAB_KEY = "enablePairingTab"
    private let ENABLE_PROTECT_TAB_KEY = "enableProtectTab"
    private let ENABLE_VERIFY_TAB_KEY = "enableVerifyTab"
    private let ENABLE_WALLET_TAB_KEY = "enableWalletTab"
    private let PAIR_TAB_NAME_KEY = "pairTabName"
    private let PROTECT_TAB_NAME_KEY = "protectTabName"
    private let VERIFY_TAB_NAME_KEY = "verifyTabName"
    private let WALLET_TAB_NAME_KEY = "walletTabName"
    private let USE_WHITE_LOGO_KEY = "useWhiteLogo"

    private let CUSTOM_BACKGROUND_COLOR_KEY = "customBackgroundColor"
    
    
    private let defaults = UserDefaults.standard

    public let allVerticals: [String] = K.allVerticals
    
    @Published var activeVertical: String
    @Published var showConfigurator = false
    @Published var userHasSetVertical = false
    
    @Published var enablePairingTab = true
    @Published var enableProtectTab = true
    @Published var enableVerifyTab = true
    @Published var enableWalletTab = false
    
    @Published var pairTabName = "Pair"
    @Published var protectTabName = "Protect"
    @Published var verifyTabName = "Verify"
    @Published var walletTabName = "Wallet"
    
    @Published var useWhiteLogo = false

    @Published var customBackgroundColor: [CGFloat]? = nil
    @Published var primaryColor: [CGFloat] = []
    @Published var secondaryColor: [CGFloat] = []
    @Published var buttonPressedColor: [CGFloat] = []

    @Published var hasCustomBackgroundColor = false
    
    init() {
        if let storedVertical = defaults.string(forKey: SELECTED_VERTICAL_KEY) {
            activeVertical = storedVertical
            enablePairingTab = defaults.bool(forKey: ENABLE_PAIRING_TAB_KEY)
            enableVerifyTab = defaults.bool(forKey: ENABLE_VERIFY_TAB_KEY)
            enableProtectTab = defaults.bool(forKey: ENABLE_PROTECT_TAB_KEY)
            enableWalletTab = defaults.bool(forKey: ENABLE_WALLET_TAB_KEY)
            useWhiteLogo = defaults.bool(forKey: USE_WHITE_LOGO_KEY)
            pairTabName = defaults.string(forKey: PAIR_TAB_NAME_KEY) ?? pairTabName
            protectTabName = defaults.string(forKey: PROTECT_TAB_NAME_KEY) ?? protectTabName
            verifyTabName = defaults.string(forKey: VERIFY_TAB_NAME_KEY) ?? verifyTabName
            walletTabName = defaults.string(forKey: WALLET_TAB_NAME_KEY) ?? walletTabName
            
            customBackgroundColor = defaults.object(forKey: CUSTOM_BACKGROUND_COLOR_KEY) as? [CGFloat]
            
            primaryColor = defaults.object(forKey: SharedConstants.primaryColorOverrideKey) as! [CGFloat]
            secondaryColor = defaults.object(forKey: SharedConstants.secondaryColorOverrideKey) as! [CGFloat]
            buttonPressedColor = defaults.object(forKey: SharedConstants.buttonPressedColorOverrideKey) as! [CGFloat]
        } else {
            activeVertical = allVerticals[0]
            
            populateInitialVerticalColors(vertical: activeVertical)
            
            // Populate initial data in UserDefaults
            defaults.set(activeVertical, forKey: SELECTED_VERTICAL_KEY)
            defaults.set(enablePairingTab, forKey: ENABLE_PAIRING_TAB_KEY)
            defaults.set(enableVerifyTab, forKey: ENABLE_VERIFY_TAB_KEY)
            defaults.set(enableProtectTab, forKey: ENABLE_PROTECT_TAB_KEY)
            defaults.set(enableWalletTab, forKey: ENABLE_WALLET_TAB_KEY)
            defaults.set(useWhiteLogo, forKey: USE_WHITE_LOGO_KEY)
            defaults.set(customBackgroundColor, forKey: CUSTOM_BACKGROUND_COLOR_KEY)
            defaults.set(pairTabName, forKey: PAIR_TAB_NAME_KEY)
            defaults.set(protectTabName, forKey: PROTECT_TAB_NAME_KEY)
            defaults.set(verifyTabName, forKey: VERIFY_TAB_NAME_KEY)
            defaults.set(walletTabName, forKey: WALLET_TAB_NAME_KEY)
        }
        
        if customBackgroundColor != nil {
            hasCustomBackgroundColor = true
        }
        
        userHasSetVertical = defaults.bool(forKey: USER_HAS_SET_VERTICAL) // False if key does not exist
    }
    
    func updateActiveVertical(vertical: String) {
        defaults.set(vertical, forKey: SELECTED_VERTICAL_KEY)
        defaults.set(true, forKey: USER_HAS_SET_VERTICAL)
        userHasSetVertical = true
        
        populateInitialVerticalColors(vertical: vertical)
    
        self.activeVertical = vertical
    }
    
    func updateProtectTab(value: Bool) {
        defaults.set(value, forKey: ENABLE_PROTECT_TAB_KEY)
    }
    
    func updateVerifyTab(value: Bool) {
        defaults.set(value, forKey: ENABLE_VERIFY_TAB_KEY)
    }
    
    func updatePairingTab(value: Bool) {
        defaults.set(value, forKey: ENABLE_PAIRING_TAB_KEY)
    }
    
    func updateWalletTab(value: Bool) {
        defaults.set(value, forKey: ENABLE_WALLET_TAB_KEY)
    }
    
    func updateUseWhiteLogo(value: Bool) {
        defaults.set(value, forKey: USE_WHITE_LOGO_KEY)
    }

    func updateCustomBackgroundColor(value: [CGFloat]?) {
        customBackgroundColor = value
        hasCustomBackgroundColor = value != nil
        
        defaults.set(value, forKey: CUSTOM_BACKGROUND_COLOR_KEY)
    }
    
    func updatePrimaryColor(value: [CGFloat]) {
        defaults.set(value, forKey: SharedConstants.primaryColorOverrideKey)
    }
    
    func updateSecondaryColor(value: [CGFloat]) {
        defaults.set(value, forKey: SharedConstants.secondaryColorOverrideKey)
    }
    
    func updateButtonPressedColor(value: [CGFloat]) {
        defaults.set(value, forKey: SharedConstants.buttonPressedColorOverrideKey)
    }
    
    func updatePairTabName(value: String) {
        defaults.set(value, forKey: PAIR_TAB_NAME_KEY)
    }
    
    func updateVerifyTabName(value: String) {
        defaults.set(value, forKey: VERIFY_TAB_NAME_KEY)
    }
    
    func updateProtectTabName(value: String) {
        defaults.set(value, forKey: PROTECT_TAB_NAME_KEY)
    }
    
    func updateWalletTabName(value: String) {
        defaults.set(value, forKey: WALLET_TAB_NAME_KEY)
    }
    
    private func populateInitialVerticalColors(vertical: String) {
        guard let primary = UIColor(named: "Color-\(vertical)-Primary")?.cgColor.components else {
            fatalError("Retrieving color 'Color-\(vertical)-Primary' from assets did not succeed")
        }
        
        primaryColor = primary
        updatePrimaryColor(value: primary)
        
        guard let secondary = UIColor(named: "Color-\(vertical)-Secondary")?.cgColor.components else {
            fatalError("Retrieving color 'Color-\(vertical)-Secondary' from assets did not succeed")
        }
        
        secondaryColor = secondary
        updateSecondaryColor(value: secondary)
        
        
        guard let buttonPressed = UIColor(named: "Color-\(vertical)-ButtonPressed")?.cgColor.components else {
            fatalError("Retrieving color 'Color-\(vertical)-ButtonPressed' from assets did not succeed")
        }
        
        buttonPressedColor = buttonPressed
        updateButtonPressedColor(value: buttonPressed)
    }
}
