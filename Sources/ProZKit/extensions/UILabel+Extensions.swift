//
//  UILabel+Extensions.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 14/2/25.
//

import UIKit

extension UILabel {
    public func addFontShadow() {
        textColor = .white
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
}
