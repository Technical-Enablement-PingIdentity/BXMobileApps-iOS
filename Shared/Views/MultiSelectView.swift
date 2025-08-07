//
//  MultiSelectView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/6/25.
//

import SwiftUI

struct MultiSelectForm: View {
    // The list of items we want to show
    let items: [MultiSelectItem]
    
    let title: String
 
    // Binding to the selected items we want to track
    @Binding var selectedItems: Set<MultiSelectItem>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 4)
                .padding(.leading)
            ForEach(items, id: \.id) { option in
                MultiSelectRow(title: option.name, isSelected: selectedItems.contains(option)) {
                    if selectedItems.contains(option) {
                        selectedItems.remove(option)
                    } else {
                        selectedItems.insert(option)
                    }
                }
            }
        }
    }
}

struct MultiSelectRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(K.Colors.Primary))
                        .font(.system(size: 20))
                        
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(Color(K.Colors.Primary))
                        .font(.system(size: 20))
                }
                Text(title)
                Spacer()
            }
            .padding()
        }
        
        Divider()
            .frame(height: 1)
            .padding(.leading)

    }
}

struct MultiSelectItem: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

#Preview(traits: .sizeThatFitsLayout) {
    struct Preview: View {
        let items = ["Item 1", "Item 2", "Item 3"].map { MultiSelectItem(name: $0) }
        @State var selectedItems = Set<MultiSelectItem>()
        
        var body: some View {
           VStack {
               MultiSelectForm(items: items, title: "Options", selectedItems: $selectedItems)
           }
        }
    }

    return Preview()
}
