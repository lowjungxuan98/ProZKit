//
//  UIView+Extensions.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 14/2/25.
//

import UIKit

public extension UIView {
    func addShaded() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = bounds
        gradientLayer.masksToBounds = true
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
