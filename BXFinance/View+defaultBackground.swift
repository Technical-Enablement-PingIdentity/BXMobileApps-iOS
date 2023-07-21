//
//  SwiftUIView.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/19/23.
//

import SwiftUI

extension View {
    func defaultBackground() -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.secondaryColor)
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea(.keyboard)
    }
}
