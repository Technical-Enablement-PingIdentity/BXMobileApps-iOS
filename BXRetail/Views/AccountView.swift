//
//  AccountView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/16/25.
//

import SwiftUI
import PingDavinci

struct AccountView: View {
    
    let actions = [
        AccountAction(id: "profile", icon: "person.crop.circle.fill", active: true),
        AccountAction(id: "messages", icon: "message.badge.fill", active: false),
        AccountAction(id: "purchase_history", icon: "cart.badge.clock.fill", active: false),
        AccountAction(id: "account_settings", icon: "gearshape.fill", active: false),
        AccountAction(id: "extraordinary_club", icon: "star.square.on.square.fill", active: false),
        AccountAction(id: "app_info", icon: "info.circle.fill", active: true),
        AccountAction(id: "sign_out", icon: "person.slash", active: true)
    ]
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            if userViewModel.isLoggedIn {

                NavigationStack() {
                    List(actions) { action in
                        NavigationLink(destination: {
                            switch action.id {
                            case "profile":
                                ScrollView {
                                    ProfileView()
                                }
                            case "app_info":
                                VersionView()
                            case "sign_out":
                                ProgressView()
                                    .onAppear {
                                        Task {
                                            GoogleAnalytics.userTappedButton(buttonName: "sign_out")
                                            await userViewModel.logoutUser()
                                        }
                                    }
                                    .navigationBarBackButtonHidden(true)
                            default:
                                EmptyView()
                            }
                        }, label:  {
                            HStack {
                                Image(systemName: action.icon)
                                    .frame(width: 20)
                                Text(LocalizedStringKey(action.id))
                            }
                        })
                        .disabled(!action.active)
                    }
                }
            } else {
                Spacer()
                SignInCardView(note: "account.not_signed_in".resource)
                    .padding(.horizontal)
                Spacer()
                VersionView()
            }
        }
    }
}

struct AccountAction: Identifiable {
    let id: String
    let icon: String
    let active: Bool
}

#Preview {
    AccountView()
}
