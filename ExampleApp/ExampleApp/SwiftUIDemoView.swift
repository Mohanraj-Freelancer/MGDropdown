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
        VStack {
            MGDropdownView(
                items: countries,
                displayKeyPath: \.self,
                selected: $selectedCountry
            )
            .padding()

            Text("Selected: \(selectedCountry ?? "--")")
                .font(.title3)

            Spacer()
        }
        .padding()
    }
}
