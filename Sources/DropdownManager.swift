//
//  DropdownManager.swift
//  
//
//  Created by Mohanraj on 13/11/25.
//


import UIKit

public final class DropdownManager {
    
    @MainActor public static let shared = DropdownManager()
    private init() {}
    
    private let overlayTag = 9998
    private let dropdownTag = 9999
    
    @MainActor public func showDropdown<T: Any>(
        from sourceView: UIView,
        in parentView: UIView,
        items: [T],
        displayKeyPath: KeyPath<T, String>,
        maxVisibleItems: Int = 7,
        rowHeight: CGFloat = 40,
        selection: @escaping (T) -> Void
    ) {
        hideDropdown(in: parentView, animated: false)
        
        let overlay = UIView(frame: parentView.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.001)
        overlay.tag = overlayTag
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        overlay.addGestureRecognizer(tap)
        parentView.addSubview(overlay)
        
        let menu = CommonDropdownView(items: items, displayKeyPath: displayKeyPath)
        menu.tag = dropdownTag
        menu.rowHeight = rowHeight
        
        menu.onItemSelected = { [weak self, weak parentView] selectedItem in
            selection(selectedItem)
            if let parent = parentView { self?.hideDropdown(in: parent) }
        }
        
        let convertedFrame = sourceView.convert(sourceView.bounds, to: parentView)
        let maxHeight = CGFloat(items.count > maxVisibleItems ? CGFloat(maxVisibleItems) * rowHeight : CGFloat(items.count) * rowHeight)
        let spaceBelow = parentView.bounds.height - convertedFrame.maxY
        let spaceAbove = convertedFrame.minY
        let shouldShowAbove = spaceBelow < maxHeight && spaceAbove > maxHeight
        let menuHeight = min(maxHeight, shouldShowAbove ? spaceAbove - 10 : spaceBelow - 10)
        let yPosition = shouldShowAbove
            ? convertedFrame.minY - menuHeight - 2
            : convertedFrame.maxY + 2
        
        menu.frame = CGRect(
            x: convertedFrame.minX,
            y: yPosition,
            width: sourceView.frame.width,
            height: menuHeight
        )
        parentView.addSubview(menu)

        // Auto-focus search
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            menu.searchBar.becomeFirstResponder()
        }

        // Fade-in animation
        menu.alpha = 0
        UIView.animate(withDuration: 0.2) {
            menu.alpha = 1
        }
    }
    
    @MainActor public func hideDropdown(in parentView: UIView, animated: Bool = true) {
        guard let dropdown = parentView.subviews.first(where: { $0.tag == dropdownTag }),
              let overlay = parentView.subviews.first(where: { $0.tag == overlayTag }) else { return }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                dropdown.alpha = 0
            }, completion: { _ in
                dropdown.removeFromSuperview()
                overlay.removeFromSuperview()
            })
        } else {
            dropdown.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }
    
    @MainActor @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        guard let parent = sender.view?.superview else { return }
        hideDropdown(in: parent)
    }
}
