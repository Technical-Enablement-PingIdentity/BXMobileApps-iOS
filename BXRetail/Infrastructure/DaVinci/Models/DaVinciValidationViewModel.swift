//
//  DaVinciValidationViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import SwiftUI

/// A view model for managing validation state across form fields.
@MainActor
public class DaVinciValidationViewModel: ObservableObject {
    /// Indicates whether validation should be performed on the current form fields.
    @Published var shouldValidate = false
}
