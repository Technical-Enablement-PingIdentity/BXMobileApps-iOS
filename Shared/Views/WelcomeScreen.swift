//
//  WelcomeScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

struct WelcomeScreen<Content: View>: View {
    
    let versionColor: Color
    let background: Content

    var versionLabel: String {
        get {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            
            return "v\(appVersion) (\(appBuild))"
        }
    }

    var body: some View {
        
        VStack {
            let logoOffset = 100.0
            
            Image("LogoWhite")
                .resizable()
                .scaledToFit()
                .padding([.leading, .trailing], 30)
                .padding(.top, logoOffset)
            
            Spacer()
            
            BXButton(text: "Getting Started".localized()) { () in
                print("Getting Started Pressed")
            }
            .padding(.top, logoOffset * -1)
            
            Spacer()
            
            Text(versionLabel)
                .foregroundColor(versionColor)
        }
        .background(background)
    }

}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        // BXFinance Preview
        WelcomeScreen(versionColor: .white, background: Color.secondaryColor.ignoresSafeArea())
        
        // BXHealth Preview
//        WelcomeScreen(versionColor: .primaryColor, background: Image("Background")
//            .resizable()
//            .ignoresSafeArea()
//            .aspectRatio(2.4, contentMode: .fill)
//            .opacity(0.8),
//        )
    }
}
