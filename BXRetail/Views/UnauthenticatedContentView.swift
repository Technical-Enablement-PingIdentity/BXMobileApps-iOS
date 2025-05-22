//
//  SaleBanner.swift
//  BXRetail
//
//  Created by Eric Anderson on 5/15/25.
//

import SwiftUI

struct UnauthenticatedContentView: View {
    var body: some View {
        
        VStack {
            Text("shop.electronics.sale")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
                .font(.system(size: 24, weight: .bold))
            ZStack {
                Image("shop-electronics")
                    .resizable()
                    .scaledToFit()
                ZStack {
                    Circle()
                        .fill(Color(K.Colors.Primary))
                    Text("shop.banner.sale")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: 100, height: 100)
                .offset(x: -130, y: -30)
            }
            
            Button("shop.banner.button".resource) {}
                .buttonStyle(BXButtonStyle())
                .padding(.bottom, 24)
            Text("shop.apparel")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
                .font(.system(size: 24, weight: .bold))
            Image("shop-apparel")
                .resizable().scaledToFit()
            Button("shop.apparel.button") {}
                .buttonStyle(BXButtonStyle())
                .padding(.bottom,24)
            
            VStack {
                Text("shop.extraordinary-club.title")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 2)
                    .padding(.top)
                    .font(.system(size: 24, weight: .bold))
                ZStack {
                    Circle()
                        .fill(Color(K.Colors.Primary))
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                    .frame(width: 100, height: 100)
                
                Text("shop.extraordinary-club.description")
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .padding(.horizontal)
                Button("shop.extraordinary-club.button") {}
                    .buttonStyle(.bordered)
                    .tint(Color(K.Colors.Primary))
                    .padding(.bottom)
            }
                .border(.gray, width: 1)
        }
    }
}

#Preview {
    ScrollView {
        UnauthenticatedContentView()
    }
}
