//
//  BXIndustryRoot.swift
//  BXIndustry
//
//  Created by Eric Anderson on 9/12/24.
//

import SwiftUI
import PingOneSDK

struct BXIndustryRootView: View {
    @ObservedObject private var model: BXIndustryMainViewModel
    @ObservedObject private var sharedModel: MainViewModel
    
    @State var displayNotificationDeniedWarning = false
    
    init() {
        self.model = BXIndustryMainViewModel.shared
        self.sharedModel = MainViewModel.shared
        
        registerNotifications { [self] displayWarning in
            self.displayNotificationDeniedWarning = displayWarning
        }
    }
    
    var body: some View {
        VStack {
            Image("Logo-\(model.activeVertical)-\(model.useWhiteLogo ? "White" : "Color")")
                .resizable()
                .scaledToFit()
                .padding([.leading, .trailing], 30)
                .padding(.top, 40)
            Spacer()
            BXIndustryHomeView()
        }
        .colorBackground(color: model.customBackgroundColor?.asColor() ?? Color.white)
        .alert("Authorize Request".localizedForApp(), isPresented: $sharedModel.displayAuthenticationAlert) {
            Button("Approve".localizedForApp()) {
                sharedModel.finishAuthenticationPrompt(userAccepted: true)
            }
            Button("Deny".localizedForApp(), role: .destructive) {
                sharedModel.finishAuthenticationPrompt(userAccepted: false)
            }
        }
        .alert("Notifications Disabled".localizedForApp(), isPresented: $displayNotificationDeniedWarning, actions: {
            Button("Dismiss".localizedForApp(), role: .cancel) {
                displayNotificationDeniedWarning = false
            }
            Button("Go to Settings".localizedForApp()) {
                displayNotificationDeniedWarning = false
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }, message: {
            Text("Notifications Disabled Message".localizedForApp())
        })
    }
}

#Preview {
    BXIndustryRootView()
}

extension BXIndustryRootView {
    // Completion Handler should be sent whether or not to display an alert to the user, only do this if they deny permission, and only when they are prompted (not when they open the app in the future)
    func registerNotifications(completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    // Need to do this either way so the Alert will pop up in the app even if they do not want push notifications.
                    if error == nil {
                        center.setNotificationCategories(PingOne.getUNNotificationCategories())
                        DispatchQueue.main.async {
                            print("Registering for remote notifications")
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    
                    if !granted {
                        print("User denied permission for push notifications.")
                    }
                    
                    completionHandler(!granted)
                }
            } else {
                completionHandler(false)
            }
        }
    }
}
