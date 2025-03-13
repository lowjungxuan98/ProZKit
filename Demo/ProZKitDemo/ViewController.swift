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
    
    lazy var customMeetingVC: CustomMeetingViewController = {
        return CustomMeetingViewController()
    }()
    
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
        ProZoomController.shared.startMeeting(
            self,
            jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiI0VDhOXzQ1RlNjYWlLd1FMMG5aVFhBIiwic2RrS2V5IjoiNFQ4Tl80NUZTY2FpS3dRTDBuWlRYQSIsImlhdCI6MTc0MTg0NzEwNiwiZXhwIjoxNzQxODU0MzA2LCJ0b2tlbkV4cCI6MTc0MTg1NDMwNn0.9GhXBSeuWTQ-zr33BsTtl1lExXYG8Gh_MO7hnQ8HKUI",
//            meetingId: "83266114104",
            meetingId: "83900650482",
//            passcode: "7Mke2h",
            passcode: "7ZGbb3",
            clinicName: "Zack Clinic",
            docterName: "Zack",
            docterNumber: "123456"
        )
    }
}
