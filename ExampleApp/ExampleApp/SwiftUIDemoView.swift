//
//  SwiftUIDemoView.swift
//  ExampleApp
//
//  Created by Mohanraj on 13/11/25.
//


import SwiftUI
import MGDropdown

struct SwiftUIDemoView: View {

    let countries = ["India", "USA", "Japan", "China", "Germany"]
    @State private var selectedCountry: String?

    var body: some View {
        VStack(spacing: 20) {

            Text("SwiftUI Demo")
                .font(.largeTitle)
                .padding(.top, 40)

            MGDropdownView(
                items: countries,
                displayKeyPath: \.self,
                selected: $selectedCountry
            )
            .frame(height: 55)
            .padding()

            Text("Selected: \(selectedCountry ?? "--")")
                .font(.title3)

            Spacer()
        }
    }
}
