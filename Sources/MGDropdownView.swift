//
//  MGDropdownView.swift
//  MGDropdown
//
//  Created by Mohanraj on 13/11/25.
//


import SwiftUI

public struct MGDropdownView<T>: View where T: Hashable {

    // MARK: - Public Inputs
    @Binding private var selection: T?
    private var items: [T]
    private var displayKeyPath: KeyPath<T, String>
    private var showSearchBar: Bool

    // MARK: - Internal State
    @State private var isExpanded = false
    @State private var searchText = ""

    // MARK: - Constants
    private let rowHeight: CGFloat = 44
    private let maxVisibleItems = 6

    // MARK: - Init
    public init(
        items: [T],
        displayKeyPath: KeyPath<T, String>,
        selected: Binding<T?>,
        showSearchBar: Bool = false
    ) {
        self.items = items
        self.displayKeyPath = displayKeyPath
        self._selection = selected
        self.showSearchBar = showSearchBar
    }

    // MARK: - Body
    public var body: some View {
        ZStack(alignment: .topLeading) {

            // 🔥 TAP OUTSIDE TO CLOSE
            if isExpanded {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { closeDropdown() }
                    .zIndex(0)
            }

            dropdownBody
                .zIndex(1)
        }
    }

    // MARK: - Dropdown + Button
    private var dropdownBody: some View {
        VStack(alignment: .leading, spacing: 0) {

            // BUTTON
            Button(action: toggleDropdown) {
                HStack {
                    Text(title)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
            }

            // LIST
            if isExpanded {
                dropdownList
            }
        }
    }

    // MARK: - Dropdown List
    private var dropdownList: some View {
        VStack(spacing: 0) {

            // SEARCH
            if showSearchBar {
                TextField("Search...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
            }

            // LIST
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredItems, id: \.self) { item in

                        Button {
                            selection = item
                            closeDropdown()
                        } label: {
                            HStack {
                                Text(item[keyPath: displayKeyPath])
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                        }
                        .frame(height: rowHeight)
                        .background(Color.white)
                        .overlay(
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(Color.gray.opacity(0.25)),
                            alignment: .bottom
                        )
                    }
                }
                .padding(.bottom, 6)
            }
            .frame(
                maxHeight: CGFloat(min(filteredItems.count, maxVisibleItems)) * rowHeight
            )

        }
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )

        // 🌈 MATERIAL FLOATING SHADOW
        .shadow(color: Color.black.opacity(0.20), radius: 20, x: 0, y: 12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)

        // 🌈 MATERIAL POP + FADE
        .transition(
            AnyTransition.scale(scale: 0.95, anchor: .top)
                .combined(with: .opacity)
        )
        .animation(
            .timingCurve(0.2, 0.0, 0.0, 1.0, duration: 0.22),
            value: isExpanded
        )
        .padding(.top, 4)
    }

    // MARK: - Helpers
    private var filteredItems: [T] {
        if searchText.isEmpty { return items }
        return items.filter {
            $0[keyPath: displayKeyPath]
                .localizedCaseInsensitiveContains(searchText)
        }
    }

    private var title: String {
        selection.map { $0[keyPath: displayKeyPath] } ?? "Select"
    }

    private func toggleDropdown() {
        withAnimation {
            isExpanded.toggle()
        }
    }

    private func closeDropdown() {
        withAnimation {
            isExpanded = false
        }
    }
}
