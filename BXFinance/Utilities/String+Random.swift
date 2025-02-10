//
//  String.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 2/7/25.
//

extension String {
    
    static func random(length: Int = 20) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
