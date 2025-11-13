//
//  CommonDropdownView.swift
//  
//
//  Created by Mohanraj on 13/11/25.
//


import UIKit

class CommonDropdownView<T>: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let items: [T]
    private let displayKeyPath: KeyPath<T, String>
    var rowHeight: CGFloat = 40
    var onItemSelected: ((T) -> Void)?
    
    init(items: [T], displayKeyPath: KeyPath<T, String>) {
        self.items = items
        self.displayKeyPath = displayKeyPath
        super.init(frame: .zero)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.layer.cornerRadius = 8
        tableView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tableView.layer.borderWidth = 0.5
        tableView.layer.shadowColor = UIColor.lightGray.cgColor
        tableView.layer.shadowOpacity = 0.8
        tableView.layer.shadowOffset = CGSize(width: 0, height: 1)
        tableView.layer.shadowRadius = 2
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = items[indexPath.row][keyPath: displayKeyPath]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onItemSelected?(items[indexPath.row])
    }
}
