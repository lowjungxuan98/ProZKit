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
        callBottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(callBottomView)
        NSLayoutConstraint.activate([
            callBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            callBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            callBottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        callBottomView.setImage(for: .endCall, with: UIImage(systemName: "phone"))
        callBottomView.startTimer()
    }
}
