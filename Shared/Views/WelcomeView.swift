//
//  WelcomeScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject private var model: MainViewModel
    
    let versionColor: Color

    init(versionColor: Color) {
        self.versionColor = versionColor;
        self.model = MainViewModel.shared;
        
        registerNotifications(completionHandler: model.shouldShowNotificationDeniedWarning)
    }
    
    var versionLabel: String {
        get {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            
            return "v\(appVersion) (\(appBuild))"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            BXButton(text: "Getting Started".localized()) { () in
                model.currentRoute = .home
            }
            
            Spacer()
            
            Text(versionLabel)
                .foregroundColor(versionColor)
        }
        .alert("Notifications Disabled".localized(), isPresented: $model.displayNotificationDeniedWarning, actions: {
            Button("Dismiss".localized(), role: .cancel) {
                model.displayNotificationDeniedWarning = false
            }
            Button("Go to Settings".localized()) {
                model.displayNotificationDeniedWarning = false
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }, message: {
            Text("Notifications Disabled Message".localized())
        })
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(versionColor: .white)
    }
}
