//
//  CommonDropdownView.swift
//  
//
//  Created by Mohanraj on 13/11/25.
//


import UIKit

public class CommonDropdownView<T>: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let tableView = UITableView()
    public let searchBar = UISearchBar()
    
    private let items: [T]
    private var filteredItems: [T]
    
    private let displayKeyPath: KeyPath<T, String>
    
    public var rowHeight: CGFloat = 40
    public var onItemSelected: ((T) -> Void)?
    public var isSearchEnabled: Bool = true   // enable/disable search
    
    // MARK: - Init
    public init(items: [T], displayKeyPath: KeyPath<T, String>) {
        self.items = items
        self.filteredItems = items
        self.displayKeyPath = displayKeyPath
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupView() {
        backgroundColor = .white
        
        // Configure Search Bar
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.isHidden = !isSearchEnabled
        
        // Table Setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 8
        tableView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tableView.layer.borderWidth = 0.5
        
        // Layout
        addSubview(searchBar)
        addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Search Filtering
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let search = searchText.lowercased()
        
        filteredItems = search.isEmpty
        ? items
        : items.filter { $0[keyPath: displayKeyPath].lowercased().contains(search) }
        
        tableView.reloadData()
    }
    
    // MARK: - Table Delegates
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filteredItems[indexPath.row][keyPath: displayKeyPath]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onItemSelected?(filteredItems[indexPath.row])
    }
}
