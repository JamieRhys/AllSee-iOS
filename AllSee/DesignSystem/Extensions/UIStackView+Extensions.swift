//
//  UIStack+Extensions.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 22/07/2025.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = 16
        insertSubview(subView, at: 0)
    }
}
