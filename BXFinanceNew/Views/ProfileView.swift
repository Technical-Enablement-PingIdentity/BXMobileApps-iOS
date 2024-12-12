//
//  ProfileView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct ProfileView: View {
    
    let pages = [
        ProfilePage(icon: "person.crop.circle.fill", name: "Profile", route: "profile"),
        ProfilePage(icon: "person.crop.circle.fill", name: "Pair App", route: "pair")
    ]
    
    var body: some View {
        List(pages) { page in
            Text(page.name)
        }
    }
}

struct ProfilePage: Identifiable {
    let id: UUID = UUID()
    let icon: String
    let name: String
    let route: String
}

#Preview {
    ProfileView()
}
