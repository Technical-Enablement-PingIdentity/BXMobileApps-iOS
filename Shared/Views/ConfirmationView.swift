//
//  ConfirmationView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/19/24.
//

import SwiftUI

struct ConfirmationView: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var model: ConfirmationViewModel

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(model.confirmationTitle)
                .font(.headline)
                .padding(.top)

            Image(systemName: model.confirmationSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(20)
                .foregroundStyle(Color.white)
                .background(Color.bxPrimary)
                .clipShape(Circle())

            Text(model.confirmationMessage)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            HStack {
                Button(LocalizedStringKey("deny")) {
                    model.completeConfirmation(userDidApprove: false)
                }
                .buttonStyle(BXFullWidthButtonStyle(backgroundColor: .red))
                .padding(.leading)
                .padding(.trailing, 4)

                Button(LocalizedStringKey("approve")) {
                    model.completeConfirmation(userDidApprove: true)
                }
                .buttonStyle(BXFullWidthButtonStyle(backgroundColor: .green))
                .padding(.leading, 4)
                .padding(.trailing)
            }

            .padding(.vertical, 16)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottom)
        .background(colorScheme == .dark ? .black : .white)

    }
}

#if DEBUG
struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        
        let confirmationModel = ConfirmationViewModel()
        
        VStack {
            ConfirmationView()
        }
        .environmentObject(confirmationModel)
        .onAppear {
            confirmationModel.presentUserConfirmation(
                title: String(localized: "confirmation.title"),
                message: String(localized: "confirmation.message"), image: "lock.open.iphone"
            ) { approved in
                print("User approved: \(approved)")
            }
        }
    }
}
#endif
