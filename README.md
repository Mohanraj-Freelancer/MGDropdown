# MGDropdown

A lightweight, reusable, customizable dropdown component for UIKit — with built-in search support and smooth animations.

## ✨ Features

- 🔍 Built-in Search Bar
- 🎨 Fully Customizable (colors, fonts, height)
- 🧱 Easy to integrate in any UIKit project
- 📦 Available via Swift Package Manager & CocoaPods
- ⚡ Zero dependencies

---

## 📦 Installation

### Swift Package Manager (SPM)

Add this to your **Package.swift**:

```swift
.package(url: "https://github.com/Mohanraj-Freelancer/MGDropdown.git", from: "1.0.6")


🚀 Usage

SwiftUI 🚀

MGDropdownView(
    items: countries,
    displayKeyPath: \.self,
    selected: $selectedCountry,
    showSearchBar: true
)
.frame(height: 55)
.padding()


UIKit 🚀

DropdownManager.shared.showSearchBar = true
DropdownManager.shared.showDropdown(
    from: myButton,
    in: self.view,
    items: countries,
    displayKeyPath: \.self
) { selected in
    print("Selected:", selected)
}
