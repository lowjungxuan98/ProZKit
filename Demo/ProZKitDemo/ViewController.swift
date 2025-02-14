//
//  ViewController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 14/2/25.
//

import UIKit
import ProZKit

class ViewController: UIViewController {
    private let callBottomView = ATCallBottomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callBottomView.setViewController(self)
        callBottomView.setImage(for: .endCall, with: UIImage(systemName: "phone"))
        callBottomView.startTimer()
    }
}
