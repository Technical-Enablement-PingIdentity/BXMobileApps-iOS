//
//  Date.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/4/24.
//

import Foundation
import DIDSDK
import PingOneWallet

class DateUtils {
    
    static func getFormattedDateFromClaimValue(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"
        let localDate = formatter.date(from: date)
        
        if let localDate {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: localDate)
        } else {
            return date
        }
    }
    
}

extension Date {
    
    func toString(outputFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = outputFormat
        return formatter.string(from: self)
    }
    
}
