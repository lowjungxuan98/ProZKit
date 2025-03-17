//
//  CustomMeetingViewController.swift
//  RTC
//
//  Created by Low Jung Xuan on 27/2/25.
//

import AVKit
import MobileRTC
import UIKit

class CustomMeetingViewController: UIViewController {
    lazy var videoView: MobileRTCVideoView = {
        let view = MobileRTCVideoView()
        view.setVideoAspect(MobileRTCVideoAspect_PanAndScan)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var myVideoView: MobileRTCVideoView = {
        let view = MobileRTCVideoView()
        view.setVideoAspect(MobileRTCVideoAspect_PanAndScan)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private let callBottomView = ATCallBottomView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(videoView)
        view.addSubview(myVideoView)
        myVideoView.bringSubviewToFront(videoView)

        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            myVideoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            myVideoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            myVideoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            myVideoView.heightAnchor.constraint(equalTo: myVideoView.widthAnchor, multiplier: 16 / 9),
        ])

        callBottomView.setViewController(self, safeArea: true)
        callBottomView.endCall = {
            MobileRTC.shared().getMeetingService()?.leaveMeeting(with: .leave)
        }
        callBottomView.setSize(for: .endCall, buttonSize: 55)

        callBottomView.camera = {
            MobileRTC.shared().getMeetingService()?.muteMyVideo(false)
            MobileRTC.shared().getMeetingService()?.switchMyCamera()
        }
        callBottomView.setText(for: .switchCamera, labelText: "Flip")

        callBottomView.mute = {
            guard let meetingService = MobileRTC.shared().getMeetingService() else {
                return
            }
            let isMuted = meetingService.isMyAudioMuted()
            let error = meetingService.muteMyAudio(!isMuted)
            switch error {
            case .success:
                print("ZOOM AUDIO SUCCESS")
            case .audioPermissionDenied:
                print("ZOOM AUDIO PERMISSION DENIED")
            case .audioNotConnected:
                print("ZOOM AUDIO NOT CONNECTED")
            case .cannotUnmuteMyAudio:
                print("ZOOM AUDIO CAN'T UNMUTE")
            case .failed:
                print("ZOOM AUDIO FAILED")
            @unknown default:
                print("ZOOM AUDIO OTHER FAILURE")
            }
        }

        callBottomView.timerLabel.textColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobileRTC.shared().getMeetingSettings()?.autoConnectInternetAudio()
        PrettyLogger.log("[CHECK CAMERA] \(MobileRTC.shared().getMeetingService()?.canUnmuteMyVideo() ?? false)")
    }

    func loadingView() {
        let vc = WaitMeetingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    func waitingHost() {
        if let waitVC = presentedViewController as? WaitMeetingViewController {
            waitVC.dismiss(animated: true)
        }
        let vc = WaitingHostViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    func reloadVideoView() {
        if let waitVC = presentedViewController as? WaitMeetingViewController {
            waitVC.dismiss(animated: true)
        }
        if let waitHVC = presentedViewController as? WaitingHostViewController {
            waitHVC.dismiss(animated: true)
        }
        callBottomView.startTimer()
    }

    func configureInfo(clinicName: String?, docterName: String?, docterNumber: String?) {
        callBottomView.configureInfo(clinicName: clinicName, doctorName: docterName, doctorNumber: docterNumber)
    }

    func onSinkMeetingActiveVideo(_ userID: UInt) {
        if MobileRTC.shared().getMeetingService()?.isMyself(userID) ?? false {
            MobileRTC.shared().getMeetingService()?.muteMyVideo(false)
            myVideoView.showAttendeeVideo(withUserID: userID)
        } else {
            videoView.showAttendeeVideo(withUserID: userID)
        }
    }

    func onSinkMeetingVideoStatusChange(_ userID: UInt) {
        if MobileRTC.shared().getMeetingService()?.isMyself(userID) ?? false {
            MobileRTC.shared().getMeetingService()?.muteMyVideo(false)
            myVideoView.showAttendeeVideo(withUserID: userID)
        } else {
            videoView.showAttendeeVideo(withUserID: userID)
        }
    }
}
