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
        case signOut
    }
    
    private let pages = [
        ProfilePage(icon: "person.crop.circle.fill", name: "Profile Information", route: .profileInformation, requiresAuthentication: true),
        ProfilePage(icon: "iphone.gen2", name: "Pair Device", route: .pairDevice, requiresAuthentication: false),
        ProfilePage(icon: "lock.shield", name: "Protect Result", route: .protect, requiresAuthentication: true),
        ProfilePage(icon: "wallet.pass", name: "Configure Digital Wallet", route: .wallet, requiresAuthentication: false),
        ProfilePage(icon: "person.slash", name: "Sign Out", route: .signOut, requiresAuthentication: false)
    ]
    
    @EnvironmentObject var router: RouterViewModel
    @EnvironmentObject var globalModel: GlobalViewModel
    
    var body: some View {
        List(pages) { page in
            if !page.requiresAuthentication || !globalModel.accessToken.isEmpty {
                HStack {
                    Image(systemName: page.icon)
                        .frame(width: 20)
                        
                    Text(page.name == "Sign Out" && globalModel.accessToken.isEmpty ? "Back to Sign In" : page.name)
                    
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
                    case .signOut:
                        if !globalModel.accessToken.isEmpty {
                            Task {
                                do {
                                    try await PingFedAuthnClient(appUrl: K.Environment.baseUrl).logout()
                                    globalModel.clearTokens()
                                    globalModel.showToast(style: .success, message: "You have successfully logged out")
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

#Preview {
    ProfileView()
        .environmentObject(RouterViewModel())
        .environmentObject(GlobalViewModel.preview)
}
