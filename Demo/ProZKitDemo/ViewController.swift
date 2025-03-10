//
//  ViewController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 14/2/25.
//

import AgoraRtcKit
import MobileRTC
import ProZKit
import UIKit

class ViewController: UIViewController {
    private let callBottomView = ATCallBottomView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(MobileRTC.shared().mobileRTCVersion() ?? "")
        callBottomView.setViewController(self, safeArea: false)
        callBottomView.setImage(for: .endCall, with: UIImage(systemName: "phone"))
        callBottomView.setSize(for: .endCall, buttonSize: 55)
        callBottomView.setText(for: .switchCamera, labelText: "Flip")
        callBottomView.startTimer()
    }
}
