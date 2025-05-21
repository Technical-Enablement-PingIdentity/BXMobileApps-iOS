//
//  ProfileView.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/20/25.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {

        VStack(spacing: 16) {
            Text("profile.heading")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            ProfileFieldView(name: "profile.email".resource, value: $userViewModel.email)
            HStack {
                ProfileFieldView(name: "profile.first_name".resource, value: $userViewModel.firstName)
                ProfileFieldView(name: "profile.last_name".resource, value: $userViewModel.lastName)
            }
            ProfileFieldView(name: "profile.phone".resource, value: $userViewModel.phone)
            ProfileFieldView(name: "profile.street_address".resource, value: $userViewModel.streetAddress)
            HStack {
                ProfileFieldView(name: "profile.city".resource, value: $userViewModel.city)
                ProfileFieldView(name: "profile.postal_code".resource, value: $userViewModel.postalCode)
            }
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .onAppear {
                Task {
                    await userViewModel.fetchUserInfo()
                }
            }
        
        Spacer()
    }
}

struct ProfileFieldView: View {
    
    var name: String
    
    @Binding var value: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
            TextField(name, text: $value)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray)
                )
                .disabled(true)
        }
    }
}

#Preview {
    ProfileView()
}
