//
//  AccountView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct AccountView: View {
    
    let account: Account
    
    var body: some View {
        VStack {
            HStack {
                Text(accountName(type: account.type))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Spacer()
                Text(verbatim: "(...\(account.id))")
                    .font(.system(size: 14))
            }
            .padding(.bottom, 2)
            
            Text("$\(account.amount)")
                .font(.system(size: 36))
                .fontWeight(.heavy)
                .padding(.bottom, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(account.type == .creditCard ? "Current Balance" : "Available Balance")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color(K.Colors.Primary))
        .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
        .listRowSeparator(.hidden, edges: .all)
    }
    
    func accountName(type: AccountType) -> String {
        switch type {
        case .checking: return "BXChecking"
        case .savings: return "BXSavings"
        case .creditCard: return "BXFinance Rewards Visa"
        }
    }
}

#Preview("Account View", traits: .sizeThatFitsLayout) {
    AccountView(account: .init(id: 1234, amount: "14,000", type: .checking))
}
