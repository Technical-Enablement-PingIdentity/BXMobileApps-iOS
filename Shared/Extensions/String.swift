//
//  String.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import Foundation

extension String {
    func localized(tableName: String = "OverrideLocalizable", bundle: Bundle = .main, comment: String = "") -> String {
        let defaultValue = NSLocalizedString(self, comment: comment)
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: defaultValue, comment: comment);
    }
}
