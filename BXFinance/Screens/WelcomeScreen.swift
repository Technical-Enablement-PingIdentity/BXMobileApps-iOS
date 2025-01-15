//
//  WelcomeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/11/24.
//

import SwiftUI
import PingOneSDK

struct WelcomeScreen: View {
    
    @EnvironmentObject private var globalModel: GlobalViewModel
    
    @EnvironmentObject private var router: RouterViewModel
    
    @State private var showNotificationDeniedAlert: Bool = false

    var body: some View {
        VStack {
            Spacer()
            LogoView(size: .large)
            Text(K.Strings.Login.Welcome)
                .font(.system(size: 28))
            Spacer()
            
            Button(K.Strings.Login.Login) {
                router.navigateTo(.login)
            }
            .buttonStyle(FinanceFullWidthButtonStyle())
            .padding(.bottom, 16)
            
            Button("Continue without Signing In") {
                router.navigateTo(.dashboard)
            }.tint(Color(K.Colors.Primary))
            
//            Button("test confirm") {
//                globalModel.presentUserConfirmation(title: "Test Title", message: "Test Message", image: "") { approved in
//                }
//            }
        }
        .padding()
//        .fullScreenCover(isPresented: $globalModel.presentConfirmation) {
//            ConfirmationView()
//        }
        .alert("Notifications Disabled", isPresented: $showNotificationDeniedAlert, actions: {
            Button("Dismiss", role: .cancel) {
                showNotificationDeniedAlert = false
            }
            Button("Go to Settings") {
                showNotificationDeniedAlert = false
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }, message: {
            Text("If you do not wish to enable notifications you will need to be in the BXFinance App on your phone before you attempt to use it for MFA.")
        })
        .onAppear {
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
                            showNotificationDeniedAlert = true
                        }
                    }
                }
            }
            
        }

    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(RouterViewModel())
        .environmentObject(GlobalViewModel.preview)
}
