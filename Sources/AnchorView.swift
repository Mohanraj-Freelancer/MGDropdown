//
//  AnchorView.swift
//  MGDropdown
//
//  Created by Mohanraj on 13/11/25.
//


import SwiftUI
import UIKit

struct AnchorView: UIViewRepresentable {

    var onCreate: (UIView) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            onCreate(view)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
