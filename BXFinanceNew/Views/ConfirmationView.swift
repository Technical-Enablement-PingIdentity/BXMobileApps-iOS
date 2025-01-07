//
//  ConfirmationView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/19/24.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var model: GlobalViewModel
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 12) {
                Text(model.confirmationTitle)
                    .font(.headline)
                    .padding(.top)
                Text(model.confirmationMessage)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                HStack {
                    Button("Deny") {
                        model.completeConfirmation(userDidApprove: false)
                    }
                    
                    Button("Approve") {
                        model.completeConfirmation(userDidApprove: true)
                    }
                }
                .padding(.top, 16)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottom)
            .background(Color.green)
            .zIndex(1)
        }
        
    }
}

#Preview {
    var globalModel = GlobalViewModel.preview
    
    VStack {
        Button("Show Alert") {
            globalModel.presentUserConfirmation(title: "Approve Sign In?", message: "You're trying to login, would you like to approve this login request?") { approved in
                print("User approved: \(approved)")
            }
        }
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .overlay(alignment: .bottom) {
        ConfirmationView()
    }
    .environmentObject(globalModel)
    .onAppear {
        globalModel.presentUserConfirmation(title: "Approve Sign In?", message: "You're trying to login, would you like to approve this login request?") { approved in
            print("User approved: \(approved)")
        }
    }
}
