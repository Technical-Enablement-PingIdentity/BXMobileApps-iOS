//
//  ProductTile.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/14/25.
//

import SwiftUI

struct ProductTileView: View {
    
    let imageName: String
    let productName: String
    let price: Decimal
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
            Text(productName)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(Color(K.Colors.Primary))
                .font(.system(size: 16, weight: .bold))
                .padding(8)
            Text(price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: 20, weight: .bold))

        }
        .frame(width: 200, height: 250)
        .border(.gray, width:1)
        .padding(.trailing, 8)
    }
}


#Preview {
    ProductTileView(imageName: "shop-monitor", productName: "Adventext 27\" LED PC Monitor with HDMI", price: 253.00)
}
