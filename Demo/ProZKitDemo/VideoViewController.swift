//
//  VideoViewController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 13/3/25.
//

import UIKit
import MobileRTC

class VideoViewController: UIViewController {
    
    // MARK: - Nested Types
    enum VideoDisplayMode {
        case preview
        case regular(userID: UInt)
        case active(userID: UInt)
    }
    
    // MARK: - UI Properties
    private lazy var preVideoView: MobileRTCPreviewVideoView = makePreviewView()
    private lazy var videoView: MobileRTCVideoView = makeVideoView()
    private lazy var activeVideoView: MobileRTCActiveVideoView = makeActiveVideoView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setupGestureRecognizer()
    }
    
    // MARK: - Configuration
    private func configureHierarchy() {
        [preVideoView, videoView, activeVideoView].forEach {
            $0.isHidden = true
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            preVideoView.topAnchor.constraint(equalTo: view.topAnchor),
            preVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            preVideoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preVideoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        updateDisplayMode(.preview)
    }
    
    private func setupGestureRecognizer() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Public Methods
    func updateDisplayMode(_ mode: VideoDisplayMode) {
        switch mode {
        case .preview:
            setPreviewMode()
        case .regular(let userID):
            showRegularVideo(for: userID)
        case .active(let userID):
            showActiveVideo(for: userID)
        }
    }
    
    // MARK: - Private Methods
    private func setPreviewMode() {
        [videoView, activeVideoView].forEach { $0.isHidden = true }
        preVideoView.isHidden = false
        preVideoView.startPreview()
    }
    
    private func showRegularVideo(for userID: UInt) {
        activeVideoView.stopAttendeeVideo()
        preVideoView.isHidden = true
        videoView.isHidden = false
        videoView.showAttendeeVideo(withUserID: userID)
    }
    
    private func showActiveVideo(for userID: UInt) {
        videoView.isHidden = true
        preVideoView.isHidden = true
        activeVideoView.showAttendeeVideo(withUserID: userID)
        activeVideoView.isHidden = false
    }
    
    // MARK: - Factory Methods
    private func makePreviewView() -> MobileRTCPreviewVideoView {
        let view = MobileRTCPreviewVideoView()
        view.setVideoAspect(.panAndScan)
        return view
    }
    
    private func makeVideoView() -> MobileRTCVideoView {
        let view = MobileRTCVideoView()
        view.setVideoAspect(.panAndScan)
        return view
    }
    
    private func makeActiveVideoView() -> MobileRTCActiveVideoView {
        let view = MobileRTCActiveVideoView()
        view.setVideoAspect(.panAndScan)
        return view
    }
    
    // MARK: - Gesture Handling
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.state == .changed else { return }
        let scale = gesture.scale
        MobileRTC.shared().getMeetingService()?.zoomCamera(scale)
    }
}
