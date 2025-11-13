//
//  MGDropdownView.swift
//  MGDropdown
//
//  Created by Mohanraj on 13/11/25.
//


import SwiftUI

public struct MGDropdownView<T>: View where T: Hashable {

    @Binding private var selection: T?
    private var items: [T]
    private var displayKeyPath: KeyPath<T, String>

    @State private var isExpanded = false
    private let rowHeight: CGFloat = 44
    private let maxVisibleItems = 6

    public init(
        items: [T],
        displayKeyPath: KeyPath<T, String>,
        selected: Binding<T?>
    ) {
        self.items = items
        self.displayKeyPath = displayKeyPath
        self._selection = selected
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // BUTTON
            Button(action: toggleDropdown) {
                HStack {
                    Text(selectionTitle)
                        .foregroundColor(selection == nil ? .blue : .black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }

            // DROPDOWN LIST
            if isExpanded {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(items, id: \.self) { item in
                            Button(action: {
                                self.selection = item
                                withAnimation(.spring()) {
                                    isExpanded = false
                                }
                            }) {
                                HStack {
                                    Text(item[keyPath: displayKeyPath])
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .frame(height: rowHeight)
                            }
                            .background(Color.white)
                            .overlay(
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray.opacity(0.3)),
                                alignment: .bottom
                            )
                        }
                    }
                }
                .frame(maxHeight: CGFloat(min(items.count, maxVisibleItems)) * rowHeight)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }

    private var selectionTitle: String {
        selection.map { $0[keyPath: displayKeyPath] } ?? "Select"
    }

    private func toggleDropdown() {
        withAnimation {
            isExpanded.toggle()
        }
    }
}
