//
//  LoginView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/29/24.
//

import SwiftUI

struct LoginScreen: View {

    @State private var username = ""
    @State private var password = ""
    
    @StateObject private var model: LoginViewModel
    
    @EnvironmentObject var router: RouterViewModel
    
    init(onLoggedIn: @escaping (String, String) -> Void) {
        _model = StateObject(wrappedValue: LoginViewModel(pingFedBaseUrl: K.Environment.baseUrl, loginCompleteCallback: onLoggedIn))
    }
    
    var body: some View {
        VStack {
            if model.fatalErrorMessage != nil {
                Spacer()
                Text(model.fatalErrorMessage!)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.red)
                Spacer()
            } else if model.processingPingFedCall {
                Spacer()
                ProgressView().controlSize(.large)
                Text("Please wait...")
                Spacer()
            } else {
                if model.loginStep == .username {
                    UsernameCollectorView(username: $username, validationMessage: $model.validationMessage) {
                        Task {
                            do {
                                try await model.submitUsername(username: username)
                                username = ""
                            } catch {
                                print("An error occurred submitting username \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                if model.loginStep == .password {
                    PasswordCollectorView(password: $password, validationMessage: $model.validationMessage, username: model.username) {
                        Task {
                            do {
                                try await model.submitPassword(password: password)
                                password = ""
                            } catch {
                                print("An error occurred submitting password \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .task {
            do {
                try await model.startAuthentication()
                print("Session started \(model.loginStep)")
            } catch {
                print("Could not start authentication session")
            }
        }
        .navigationTitle("Login")
    }
}

#Preview {
    NavigationStack {
        LoginScreen { accessToken, idToken in
            print("Access Token: \(accessToken), ID Token: \(idToken)")
        }.environmentObject(RouterViewModel())
    }
}
