//
//  ConfirmationView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/19/24.
//

import SwiftUI

struct ConfirmationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: GlobalViewModel
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 16) {
                Divider()
                    .background(.black)
                
                Text(model.confirmationTitle)
                    .font(.headline)
                    .padding(.top)

                Image(systemName: model.confirmationSymbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(20)
                    .foregroundStyle(Color.white)
                    .background(Color(K.Colors.Primary))
                    .clipShape(Circle())
                
                Text(model.confirmationMessage)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                    
                HStack {
                    Button("Deny") {
                        model.completeConfirmation(userDidApprove: false)
                    }
                    .buttonStyle(FinanceFullWidthButtonStyle(backgroundColor: Color.red))
                    .padding(.leading)
                    .padding(.trailing, 4)
                    
                    Button("Approve") {
                        model.completeConfirmation(userDidApprove: true)
                    }
                    .buttonStyle(FinanceFullWidthButtonStyle(backgroundColor: Color.green))
                    .padding(.leading, 4)
                    .padding(.trailing)
                }
                .padding(.vertical, 16)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottom)
            .background(colorScheme == .dark ? .black : .white)
            .zIndex(1)
        }
        
    }
}

#Preview {
    let globalModel = GlobalViewModel.preview
    
    VStack {
        Button("Show Alert") {
            globalModel.presentUserConfirmation(title: K.Strings.Confirmation.Title, message: K.Strings.Confirmation.Message, image: "lock.open.iphone") { approved in
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
        globalModel.presentUserConfirmation(title: K.Strings.Confirmation.Title, message: K.Strings.Confirmation.Message, image: "lock.open.iphone") { approved in
            print("User approved: \(approved)")
        }
    }
}
