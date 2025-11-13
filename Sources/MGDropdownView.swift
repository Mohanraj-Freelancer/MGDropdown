//
//  MGDropdownView.swift
//  MGDropdown
//
//  Created by Mohanraj on 13/11/25.
//


import SwiftUI
import UIKit

public struct MGDropdownView<T>: View where T: Hashable {

    @Binding private var selection: T?
    private var items: [T]
    private var displayKeyPath: KeyPath<T, String>

    @State private var anchorView = UIView()

    public init(
        items: [T],
        displayKeyPath: KeyPath<T, String>,
        selected: Binding<T?>
    ) {
        self._selection = selected
        self.items = items
        self.displayKeyPath = displayKeyPath
    }

    public var body: some View {
        ZStack {
            Button(action: openDropdown) {
                HStack {
                    Text(selectionTitle)
                    Spacer()
                    Image(systemName: "chevron.down")
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

            // Anchor for UIKit dropdown
            AnchorView { view in
                self.anchorView = view
            }
            .frame(width: 0, height: 0)
        }
    }

    // MARK: - Helpers
    private var selectionTitle: String {
        selection.map { $0[keyPath: displayKeyPath] } ?? "Select"
    }

    private func openDropdown() {
        guard let window = UIWindow.keyWindow else { return }
        guard let hostVC = window.rootViewController?.topMostViewController else { return }

        DropdownManager.shared.showDropdown(
            from: anchorView,
            in: hostVC.view,
            items: items,
            displayKeyPath: displayKeyPath
        ) { selectedItem in
            self.selection = selectedItem
        }
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController ?? nav
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        if let presented = presentedViewController {
            return presented.topMostViewController
        }
        return self
    }
}
