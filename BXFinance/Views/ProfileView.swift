//
//  ProfileView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct ProfileView: View {
    
    enum ProfileRoute {
        case profileInformation
        case pairDevice
        case protect
        case wallet
        case sendLogs
        case signOut
    }
    
    private let pages = [
        ProfilePage(icon: "person.crop.circle.fill", name: "Profile Information", route: .profileInformation, requiresAuthentication: true),
        ProfilePage(icon: "iphone.gen2", name: String(localized: "profile.pair_device"), route: .pairDevice, requiresAuthentication: false),
        ProfilePage(icon: "lock.shield", name: String(localized: "profile.protect"), route: .protect, requiresAuthentication: true),
        ProfilePage(icon: "wallet.pass", name: String(localized: "profile.wallet"), route: .wallet, requiresAuthentication: false),
        ProfilePage(icon: "note.text", name: String(localized: "profile.send_logs"), route: .sendLogs, requiresAuthentication: false),
        ProfilePage(icon: "person.slash", name: String(localized: "profile.sign_out"), route: .signOut, requiresAuthentication: false)
    ]
    
    @EnvironmentObject var router: RouterViewModel
    @EnvironmentObject var globalModel: FinanceGlobalViewModel
    
    var body: some View {
        List(pages) { page in
            if !page.requiresAuthentication || !globalModel.accessToken.isEmpty {
                HStack {
                    Image(systemName: page.icon)
                        .frame(width: 20)
                        
                    Text(page.name == String(localized: "profile.sign_out") && globalModel.accessToken.isEmpty ? String(localized: "profile.sign_in") : page.name)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .onTapGesture {
                    switch page.route {
                    case .profileInformation:
                        router.navigateTo(.profileInformation)
                    case .pairDevice:
                        router.navigateTo(.pairDevice)
                    case .protect:
                        router.navigateTo(.protect(JWTUtilities.decode(jwt: globalModel.accessToken)["sub"] as? String ?? ""))
                    case .wallet:
                        router.navigateTo(.wallet)
                    case .sendLogs:
                        router.navigateTo(.sendLogs)
                    case .signOut:
                        if !globalModel.accessToken.isEmpty {
                            Task {
                                GoogleAnalytics.userTappedButton(buttonName: "sign_out")
                                do {
                                    try await PingFedAuthnClient(appUrl: K.Environment.baseUrl).logout()
                                    globalModel.clearTokens()
                                    ToastPresenter.show(style: .success, toast: String(localized: "profile.sign_out_successful"))
                                } catch {
                                    print("Could not logout: \(error.localizedDescription)")
                                }
                            }
                        }

                        router.popToRoot()
                    }
                }
            }
        }
    }
    
    struct ProfilePage: Identifiable {
        let id: UUID = UUID()
        let icon: String
        let name: String
        let route: ProfileRoute
        let requiresAuthentication: Bool
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(RouterViewModel())
            .environmentObject(FinanceGlobalViewModel.preview)
    }
}
#endif
