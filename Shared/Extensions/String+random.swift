//
//  String+random.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import Foundation

extension String {

    static func random(length: Int = 20) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
