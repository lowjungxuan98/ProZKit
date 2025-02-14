//
//  UIView+Extensions.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 14/2/25.
//

import UIKit

extension UIView {
    public func addShaded() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = true
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
