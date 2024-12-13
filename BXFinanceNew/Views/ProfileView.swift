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
    }
    
    private let pages = [
        ProfilePage(icon: "person.crop.circle.fill", name: "Profile Information", route: .profileInformation),
        ProfilePage(icon: "iphone.gen2", name: "Pair Device", route: .pairDevice),
        ProfilePage(icon: "lock.shield", name: "Protect Result", route: .protect),
    ]
    
    @EnvironmentObject var router: RouterViewModel
    @EnvironmentObject var globalModel: GlobalViewModel
    
    var body: some View {
        List(pages) { page in
            HStack {
                Image(systemName: page.icon)
                    .frame(width: 20)
                    
                Text(page.name)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                switch page.route {
                case .profileInformation:
                    router.navigateTo(.profileInformation)
                case .pairDevice:
                    print("TK")
                case .protect:
                    print("Navigating to protect")
                    router.navigateTo(.protect(JWTUtilities.decode(jwt: globalModel.accessToken)["sub"] as? String ?? ""))
                }
            }
        }
    }
    
    struct ProfilePage: Identifiable {
        let id: UUID = UUID()
        let icon: String
        let name: String
        let route: ProfileRoute
    }
}

#Preview {
    ProfileView()
        .environmentObject(RouterViewModel())
        .environmentObject(GlobalViewModel.preview)
}
