//
//  MultiSelectView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/6/25.
//

import SwiftUI

struct MultiSelectView: View {
    let title: String
    
    var readOnly = false
    
    // The list of items we want to show
    let items: [MultiSelectOption]
 
    // Binding to the selected items we want to track
    @Binding var selectedItems: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .padding(.bottom, 4)
                .padding(.top, 8)
                .textCase(.uppercase)
            ForEach(items, id: \.value) { option in
                MultiSelectRowView(option: option, readOnly: readOnly, isSelected: selectedItems.contains(option.label)) {
                    if let index = selectedItems.firstIndex(of: option.label) {
                        selectedItems.remove(at: index)
                    } else {
                        selectedItems.append(option.label)
                    }
                }
            }
        }
    }
}

struct MultiSelectRowView: View {
    var option: MultiSelectOption
    var readOnly = false
    var isSelected: Bool
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(option.label)
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .font(.system(size: 12, weight: .light))
                        
                    Text(option.value)
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .fontWeight(.bold)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.bxPrimary)
                    .font(.system(size: 20))

            }
            .padding(.vertical, 8)
        }
        .disabled(readOnly)
        
        Divider()
            .frame(height: 1)
    }
}

struct MultiSelectOption {
    let label: String
    let value: String
}

#Preview(traits: .sizeThatFitsLayout) {
    struct Preview: View {
        let items = [MultiSelectOption(label: "Label 1", value: "Item 1"), MultiSelectOption(label: "Label 2", value: "Item 2"), MultiSelectOption(label: "Label 3", value: "Item 3")]
        
        @State var selectedItems = ["Item 1"]
        
        var body: some View {
           VStack {
               MultiSelectView(title: "Options", readOnly: false, items: items, selectedItems: $selectedItems)
           }
        }
    }

    return Preview()
}
