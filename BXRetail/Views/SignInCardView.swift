//
//  SignInCard.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/14/25.
//

import SwiftUI
import PingDavinci

struct SignInCardView: View {
    
    let note: String
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var popoverPresented = false
    @State private var hideClose = false
    
    var body: some View {
        VStack {
            Text(note)
                .padding(.bottom, 8)
                .multilineTextAlignment(.center)
            Button(LocalizedStringKey("sign_in")) {
                GoogleAnalytics.userTappedButton(buttonName: "sign_in")
                popoverPresented = true
            }
            .buttonStyle(BXButtonStyle())
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .border(.gray, width: 1)
        .sheet(isPresented: $popoverPresented) {
            VStack {
                DaVinciView(daVinciClient: userViewModel.loginFlowClient) {
                    Task {
                        hideClose = true
                        await userViewModel.fetchUserInfo()
                        popoverPresented = false
                        hideClose = false
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if !hideClose {
                        Button(action: {
                            popoverPresented = false
                        }) {
                            Image(systemName: "xmark")
                        }
                        .font(.system(size: 24))
                        .padding(.top)
                        .padding(.trailing)
                    }
                }
            }
        }
    }
}

#Preview("Sign In Card", traits: .sizeThatFitsLayout) {
    SignInCardView(note: "sign_in.experience".resource)
}
