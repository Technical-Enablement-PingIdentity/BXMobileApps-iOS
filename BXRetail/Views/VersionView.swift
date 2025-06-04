//
//  VersionView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 6/4/25.
//

import SwiftUI

struct VersionView: View {
    var body: some View {
        VStack {
            Text("App Version: v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                .font(.system(size: 12))
                .padding(.bottom, 2)
            Text("PingSDK Version: v1.1.0") // Sadly this must be hardcoded 😔
                .font(.system(size: 12))
                .padding(.bottom)
        }
    }
}
