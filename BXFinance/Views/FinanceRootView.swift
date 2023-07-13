//
//  FinanceHome.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct FinanceRootView: View {
    
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
                .padding(.top, 80)
            
            switch model.currentRoute {
            case .welcome: WelcomeView(versionColor: .white)
            case .home: FinanceHomeView()
            }
            
            Spacer().frame(height: 50)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color.secondaryColor)
        .animation(.default, value: model.currentRoute)
    }
}

struct FinanceRootView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceRootView()
    }
}
