//
//  UIKitDemoViewController.swift
//  ExampleApp
//
//  Created by Mohanraj on 13/11/25.
//


import UIKit
import MGDropdown

class UIKitDemoViewController: UIViewController {

    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Fruit", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let selectedLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Selected: None"
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let fruits = ["Apple", "Banana", "Orange", "Mango", "Grapes"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "UIKit Demo"

        setupUI()

        button.addTarget(self, action: #selector(showDropdown), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(button)
        view.addSubview(selectedLabel)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, offset: 40),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),

            selectedLabel.topAnchor.constraint(equalTo: button.bottomAnchor, offset: 20),
            selectedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func showDropdown() {
        DropdownManager.shared.showDropdown(
            from: button,
            in: self.view,
            items: fruits,
            displayKeyPath: \.self
        ) { selectedItem in
            self.selectedLabel.text = "Selected: \(selectedItem)"
        }
    }
}
