//
//  ViewController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 14/2/25.
//

import MobileRTC
import ProZKit
import UIKit

class ViewController: UIViewController {
    let joinButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join Meeting", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ProZoomController.shared.initialize()
    }

    private func setupUI() {
        title = "RTC"
        view.addSubview(joinButton)
        NSLayoutConstraint.activate([
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        joinButton.addTarget(self, action: #selector(joinMeeting), for: .touchUpInside)
    }

    @objc func joinMeeting() {
//        callBottomView.setImage(for: .endCall, with: UIImage(systemName: "phone"))

        ProZoomController.shared.startMeeting(
            self,
            jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiI0VDhOXzQ1RlNjYWlLd1FMMG5aVFhBIiwic2RrS2V5IjoiNFQ4Tl80NUZTY2FpS3dRTDBuWlRYQSIsImlhdCI6MTc0MTg1NDA0OCwiZXhwIjoxNzQxODYxMjQ4LCJ0b2tlbkV4cCI6MTc0MTg2MTI0OH0.7VaY_TmvuO--HJ56k_kjel_0KL_RGAZ7QLAb1xwz3FM",
            meetingId: "83266114104",
            passcode: "7Mke2h",
            clinicName: "Zack Clinic",
            docterName: "Zack",
            docterNumber: "123456"
        )
    }
}
