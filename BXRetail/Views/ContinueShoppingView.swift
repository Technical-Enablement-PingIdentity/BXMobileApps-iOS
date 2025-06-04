//
//  ContinueShopping.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/14/25.
//

import SwiftUI

struct ContinueShoppingView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("welcome \(userViewModel.displayName)")
                .lineLimit(1)
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

            Text("continue_shopping")
                .font(.system(size: 22, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack {
                    ProductTileView(imageName: "shop.monitor.image".resource, productName: "shop.monitor.title".resource, price: Decimal(string: "shop.monitor.price".resource) ?? 0.0)
                    ProductTileView(imageName: "shop.tv.image".resource, productName: "shop.tv.title".resource, price: Decimal(string: "shop.tv.price".resource) ?? 0.0)
                    ProductTileView(imageName: "shop.streamstick.image".resource, productName: "shop.streamstick.title".resource, price: Decimal(string: "shop.streamstick.price".resource) ?? 0.0)
                    ProductTileView(imageName: "shop.router.image".resource, productName: "shop.router.title".resource, price: Decimal(string: "shop.router.price".resource) ?? 0.0)
                    ProductTileView(imageName: "shop.tablet.image".resource, productName: "shop.tablet.title".resource, price: Decimal(string: "shop.tablet.price".resource) ?? 0.0)
                    ProductTileView(imageName: "shop.laptop.image".resource, productName: "shop.laptop.title".resource, price: Decimal(string: "shop.laptop.price".resource) ?? 0.0)
                }
            }
        }
    }
}

#Preview {
    ContinueShoppingView()
}
