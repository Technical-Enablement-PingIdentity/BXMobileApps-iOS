//
//  HealthView.swift
//  BXHealth
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct HealthRootView: View {
    @ObservedObject private var model: MainViewModel
    
    init() {
        self.model = MainViewModel.shared
    }
    
    var body: some View {
        
        VStack {
            Image("LogoWhite")
                .resizable()
                .scaledToFit()
                .padding([.leading, .trailing], 30)
                .padding(.top, 100)
            
            
            switch model.currentRoute {
            case .welcome: WelcomeView(versionColor: .primaryColor)
            case .home: HealthHomeView()
            }
            Spacer().frame(height: 50)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Image("Background")
            .resizable()
            .ignoresSafeArea()
            .aspectRatio(2.4, contentMode: .fill)
            .opacity(0.8))
    }
}

struct HealthRootView_Previews: PreviewProvider {
    static var previews: some View {
        HealthRootView()
    }
}
