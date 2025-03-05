//
//  PairDeviceView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/18/24.
//

import SwiftUI

struct PairDeviceView: View {
    
    @State private var pairingClientReady = false
    @State private var pairingClientInitializationError = false
    @State private var devicePairingClient: DevicePairingClient? = nil
    
    @State private var showNotificationDeniedAlert: Bool = false
    
    @EnvironmentObject var confirmationModel: ConfirmationViewModel
    
    func pairingClientReady(successful: Bool) {
        if successful {
            self.pairingClientReady = true
        } else {
            self.pairingClientInitializationError = true
        }
    }
    
    let username: String?
    
    init(username: String? = nil) {
        self.username = username
    }
    
    var body: some View {
        VStack {
            if !pairingClientReady && !pairingClientInitializationError {
                Spacer()
                Text(LocalizedStringKey("loading"))
                ProgressView()
                Spacer()
            }
            
            if pairingClientInitializationError {
                Text(LocalizedStringKey("pairing.initialization_error"))
            }
            
            if pairingClientReady {
                Button(LocalizedStringKey("pairing.pair_device")) {
                    GoogleAnalytics.userTappedButton(buttonName: "pair_device")
                    devicePairingClient?.pairDevice(username: self.username) { pairingObject in
                        guard let pairingObject else {
                            ToastPresenter.show(style: .error, toast: String(localized: "pairing.error"))
                            print("Error pairing object was nil")
                            GoogleAnalytics.userCompletedAction(actionName: "pair_device", actionSuccesful: false)
                            return
                        }
                        
                        confirmationModel.presentUserConfirmation(title: String(localized: "pairing.approve.title"), message: String(localized: "pairing.approve.message"), image: "lock.open.iphone") { userConfirmed in
                            if userConfirmed {
                                pairingObject.approve { response, error in
                                    if let error {
                                        ToastPresenter.show(style: .error, toast: String(localized: "pairing.response_unsuccessful"))
                                        print("An error occured while pairing device: \(error)")
                                        GoogleAnalytics.userCompletedAction(actionName: "pair_device", actionSuccesful: false)
                                    } else {
                                        ToastPresenter.show(style: .success, toast: String(localized: "pairing.successful"))
                                        GoogleAnalytics.userCompletedAction(actionName: "pair_device", actionSuccesful: true)
                                    }
                                }
                            } else {
                                ToastPresenter.show(style: .error, toast: String(localized: "pairing.cancelled"))
                                GoogleAnalytics.userCompletedAction(actionName: "pair_device_cancelled")
                            }
                        }
                    }
                }
                .buttonStyle(BXButtonStyle())
            }

        }
        .alert(LocalizedStringKey("notifications.disabled"), isPresented: $showNotificationDeniedAlert, actions: {
            Button("dismiss", role: .cancel) {
                GoogleAnalytics.userTappedButton(buttonName: "notification_dismiss")
                showNotificationDeniedAlert = false
            }
            Button(LocalizedStringKey("go_to_settings")) {
                GoogleAnalytics.userTappedButton(buttonName: "go_to_settings")
                showNotificationDeniedAlert = false
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }, message: {
            Text(LocalizedStringKey("notifications.warning"))
        })
        .onAppear {
            PushNotificationService.registerForPushNotifications { granted in
                if !granted {
                    showNotificationDeniedAlert = true
                }
                
                let client = DevicePairingClient {
                    successful in
                    if successful {
                        self.pairingClientReady = true
                    } else {
                        self.pairingClientInitializationError = true
                    }
                }
                
                self.devicePairingClient = client
            }
        }
    }
}

#Preview {
    PairDeviceView()
}
