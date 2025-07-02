//
//  VersionView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 6/4/25.
//

import SwiftUI

struct VersionView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("app_version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                .font(.system(size: 12))
                .padding(.bottom, 2)
            Text("ping_sdk_version")
                .font(.system(size: 12))
                .padding(.bottom, 2)
            Text("environment: \(userViewModel.clientUsingQa ? "QA" : "Prod")")
                .font(.system(size: 12))
                .padding(.bottom)
        }
    }
}
