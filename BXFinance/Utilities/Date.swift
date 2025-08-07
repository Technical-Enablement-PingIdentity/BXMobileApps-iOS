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
    
    static func getIssueDate(from claim: Claim) -> String? {
        return getDisplayStringFromISO8691(claim.getCreateDate())
    }
    
    static func getDisplayStringFromISO8691(_ iso8601Str: String) -> String? {
        guard let date = ISO8601DateFormatter().date(from: iso8601Str) else {
            return nil
        }
        return date.toString(outputFormat: "MMM dd, yyyy")
    }
    
    static func getFormattedDateFromClaimValue(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"
        let localDate = formatter.date(from: date)
        
        if let localDate {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: localDate)
        } else {
            return ""
        }
        
    }
    
}
