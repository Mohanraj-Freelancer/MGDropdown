//
//  MGDropdownView.swift
//  MGDropdown
//
//  Created by Mohanraj on 13/11/25.
//


import SwiftUI
import UIKit

public struct MGDropdownView<T>: View {

    @Binding private var selection: T?
    private var items: [T]
    private var displayKeyPath: KeyPath<T, String>

    private var buttonTitle: String {
        if let selected = selection {
            return selected[keyPath: displayKeyPath]
        }
        return "Select"
    }

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
        Button(action: openDropdown) {
            HStack {
                Text(buttonTitle)
                    .foregroundColor(.black)
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
    }

    // MARK: - Show UIKit Dropdown
    private func openDropdown() {
        guard let root = UIWindow.keyWindow else { return }

        // Convert SwiftUI view to actual UIKit view frame
        if let hostVC = root.rootViewController?.topMostViewController {
            DropdownManager.shared.showDropdown(
                from: hostVC.view,
                in: hostVC.view,
                items: items,
                displayKeyPath: displayKeyPath
            ) { selectedItem in
                self.selection = selectedItem
            }
        }
    }
}

// MARK: - Helpers to fetch top-most ViewController
extension UIWindow {
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController ?? nav
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
