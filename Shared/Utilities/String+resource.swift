//
//  String+resource.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/15/25.
//

import Foundation

extension String {
    var resource: String {
        return NSLocalizedString(self, comment: "")
    }
}
