# MGDropdown

A lightweight, reusable, customizable dropdown component for UIKit — with built-in search support and smooth animations.

## ✨ Features

- 🔍 Built-in Search Bar
- 🔍 Optional search field
- 🎨 Fully Customizable (colors, fonts, height)
- 🧱 Easy to integrate in any UIKit & SwiftUI project
- 🧩 SwiftUI component
- 🔧 UIKit dropdown manager
- 📦 Available via **Swift Package Manager** & **CocoaPods**
- ⚡ Zero dependencies
- 🎨 Material-style animation (fade + pop)
- 📱 iOS 14+ support  
- 💡 Works with **any model** via KeyPath  
---

## 📦 Installation

### Swift Package Manager (SPM)

Add this to your **Package.swift**:

```swift
.package(url: "https://github.com/Mohanraj-Freelancer/MGDropdown.git", from: "1.0.6")

CocoaPods
Use CocoaPods.

Add pod 'MGDropdown' to your Podfile.
Install the pod(s) by running pod install.
Add import MGDropdown in the .swift files where you want to use it

🚀 Quick Usage
Basic Setup
import MGDropdown

let dropdown = MGDropdown()
dropdown.anchorView = yourTextField          // Any UIView
dropdown.optionArray = ["India", "USA", "UK"]
dropdown.selectionAction = { selectedValue, index in
    print("Selected: \(selectedValue)")
}
dropdown.show()

🔧 Advanced Usage
Using model instead of string
struct City {
    let id: Int
    let name: String
}

let cities = [
    City(id: 1, name: "Chennai"),
    City(id: 2, name: "Bangalore")
]

dropdown.optionArray = cities.map { $0.name }

🎨 Customization
dropdown.rowHeight = 45
dropdown.cornerRadius = 12
dropdown.backgroundColor = .white
dropdown.textColor = .darkGray
dropdown.highlightColor = .systemBlue
dropdown.isSearchEnabled = true
dropdown.maxHeight = 300


📚 Full Example
let dropdown = MGDropdown()
dropdown.anchorView = countryField
dropdown.optionArray = ["India", "Japan", "France"]

dropdown.isSearchEnabled = true
dropdown.cornerRadius = 12
dropdown.rowHeight = 44

dropdown.selectionAction = { value, index in
    countryField.text = value
}

🧪 Example Project
The repo includes an Example project to help you understand integration.


📄 License
MGDropdown is available under the MIT License.
You are free to use it in personal and commercial projects.
