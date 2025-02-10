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
            Text(LocalizedStringKey("welcome"))
                .font(.system(size: 28))
            Spacer()
            
            Button(LocalizedStringKey("sign_in")) {
                router.navigateTo(.login)
            }
            .buttonStyle(FinanceFullWidthButtonStyle())
            .padding(.bottom, 16)
            
            Button(LocalizedStringKey("skip_sign_in")) {
                router.navigateTo(.dashboard)
            }
            .tint(Color(K.Colors.Primary))
            .padding(.bottom, 8)
            
            Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                .font(.system(size: 12))
        }
        .padding()
        .alert(LocalizedStringKey("notifications.disabled"), isPresented: $showNotificationDeniedAlert, actions: {
            Button("dismiss", role: .cancel) {
                showNotificationDeniedAlert = false
            }
            Button(LocalizedStringKey("go_to_settings")) {
                showNotificationDeniedAlert = false
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }, message: {
            Text(LocalizedStringKey("notifications.warning"))
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

#if DEBUG
struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .environmentObject(RouterViewModel())
            .environmentObject(GlobalViewModel.preview)
    }
}
#endif
