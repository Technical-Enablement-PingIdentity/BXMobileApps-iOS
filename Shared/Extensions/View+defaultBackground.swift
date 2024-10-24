//
//  SwiftUIView.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/19/23.
//

import SwiftUI

extension View {
    func colorBackground(color: Color) -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(color)
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea(.keyboard)
    }
}
