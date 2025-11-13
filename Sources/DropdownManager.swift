//
//  DropdownManager.swift
//  
//
//  Created by Mohanraj on 13/11/25.
//


import UIKit

public final class DropdownManager: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    public static let shared = DropdownManager()
    private override init() {}

    // MARK: Internal storage
    private var items: [Any] = []
    private var filteredItems: [Any] = []
    private var displayKeyPath: AnyKeyPath!
    private var onSelect: ((Any) -> Void)?
    private weak var parentView: UIView?

    // MARK: UI Elements
    private var dropdownView = UIView()
    private var tableView = UITableView()
    private var searchField = UITextField()

    // MARK: Config
    public var showSearchBar: Bool = false
    private let overlayTag = 48001
    private let dropdownTag = 48002

    // MARK: - PUBLIC API (Show Dropdown)
    public func showDropdown<T>(
        from sourceView: UIView,
        in parentView: UIView,
        items: [T],
        displayKeyPath: KeyPath<T, String>,
        maxVisibleItems: Int = 6,
        rowHeight: CGFloat = 44,
        selection: @escaping (T) -> Void
    ) {
        hideDropdown(in: parentView, animated: false)

        self.items = items
        self.filteredItems = items
        self.displayKeyPath = displayKeyPath
        self.onSelect = { any in selection(any as! T) }
        self.parentView = parentView

        // MARK: Overlay
        let overlay = UIView(frame: parentView.bounds)
        overlay.tag = overlayTag
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.001)
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideTap)))
        parentView.addSubview(overlay)

        // MARK: Dropdown Container
        dropdownView = UIView()
        dropdownView.tag = dropdownTag
        dropdownView.layer.cornerRadius = 10
        dropdownView.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        dropdownView.layer.borderWidth = 0.5
        dropdownView.backgroundColor = .white

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        dropdownView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: dropdownView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: dropdownView.bottomAnchor)
        ])

        // MARK: Search TextField (Instead of UISearchBar)
        if showSearchBar {
            searchField = UITextField()
            searchField.placeholder = "Search..."
            searchField.borderStyle = .none
            searchField.autocorrectionType = .no
            searchField.autocapitalizationType = .none
            searchField.backgroundColor = UIColor(white: 0.95, alpha: 1)
            searchField.layer.cornerRadius = 8
            searchField.setLeftPaddingPoints(10)
            searchField.delegate = self

            let searchContainer = UIView()
            searchContainer.backgroundColor = .clear
            searchContainer.addSubview(searchField)

            searchField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchField.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 8),
                searchField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 8),
                searchField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -8),
                searchField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -8),
                searchField.heightAnchor.constraint(equalToConstant: 36)
            ])

            stack.addArrangedSubview(searchContainer)
        }

        // MARK: Table
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        stack.addArrangedSubview(tableView)

        parentView.addSubview(dropdownView)

        // MARK: Positioning
        let src = sourceView.convert(sourceView.bounds, to: parentView)
        let height = min(CGFloat(filteredItems.count), CGFloat(maxVisibleItems)) * rowHeight
            + (showSearchBar ? 52 : 0)

        dropdownView.frame = CGRect(
            x: src.minX,
            y: src.maxY + 5,
            width: src.width,
            height: height
        )

        dropdownView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.dropdownView.alpha = 1
        }
    }

    // MARK: Hide
    @objc public func hideTap() {
        if let parent = parentView {
            hideDropdown(in: parent)
        }
    }

    public func hideDropdown(in parentView: UIView, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.dropdownView.alpha = 0
            }, completion: { _ in
                parentView.viewWithTag(self.overlayTag)?.removeFromSuperview()
                parentView.viewWithTag(self.dropdownTag)?.removeFromSuperview()
            })
        } else {
            parentView.viewWithTag(overlayTag)?.removeFromSuperview()
            parentView.viewWithTag(dropdownTag)?.removeFromSuperview()
        }
    }

    // MARK: - Table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filteredItems[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = (item as Any)[keyPath: displayKeyPath] as? String
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.row]
        onSelect?(item)
        if let parent = parentView { hideDropdown(in: parent) }
    }

    // MARK: - UITextField Search
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

        if newText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter {
                let value = ($0 as Any)[keyPath: displayKeyPath] as! String
                return value.lowercased().contains(newText.lowercased())
            }
        }

        tableView.reloadData()
        return true
    }
}

// MARK: - UITextField Padding Helper
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
