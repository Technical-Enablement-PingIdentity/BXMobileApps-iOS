//
//  GoogleAnalytics.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 3/5/25.
//

import FirebaseAnalytics

final class GoogleAnalytics {
    static func userLoggedIn(loginMethod: String) {
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
            AnalyticsParameterMethod: loginMethod
        ])
    }
    
    static func userViewedScreen(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterItemName: screenName
        ])
    }
    
    static func userTappedButton(buttonName: String) {
        customAction(eventName: "button_tapped", itemName: buttonName)
    }
    
    static func userCompletedAction(actionName: String, actionSuccesful: Bool = true, type: String? = nil) {
        var parameters = [
            AnalyticsParameterItemName: actionName,
            AnalyticsParameterSuccess: actionSuccesful ? "1" : "0",
        ]
        
        if let type {
            parameters[AnalyticsParameterContentType] = type
        }
        
        Analytics.logEvent("action_complete", parameters: parameters)
    }
    
    static func customAction(eventName: String, itemName: String) {
        Analytics.logEvent(eventName, parameters: [
            AnalyticsParameterItemName: itemName,
        ])
    }
}
