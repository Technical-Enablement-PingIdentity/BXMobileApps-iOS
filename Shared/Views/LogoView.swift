//
//  LogoView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct LogoView: View {
    enum LogoSize {
        case small
        case large
    }
    
    let size: LogoSize
    let assetName: String
    
    init (assetName: String, size: LogoSize = .small) {
        self.size = size
        self.assetName = assetName
    }
    
    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(width: size == .large ? 280 : 200)
    }
}

#Preview {
    LogoView(assetName: "BXFinanceLogo")
}
