//
//  ATCallBottomView.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 14/2/25.

import UIKit

public class ATCallBottomView: UIView {
    
    public enum ButtonType {
        case mute, endCall, switchCamera
    }
    
    public let clinicNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.addFontShadow()
        return label
    }()
    
    public let doctorMCRLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.addFontShadow()
        return label
    }()
    
    public let dashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.isHidden = true
        label.addFontShadow()
        return label
    }()
    
    public let doctorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.addFontShadow()
        return label
    }()
    
    public lazy var doctorInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [doctorMCRLabel, dashLabel, doctorNameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.distribution = .equalSpacing
        return stack
    }()
    
    public let muteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let icon = UIImage(systemName: "speaker.slash.fill") {
            button.setImage(icon, for: .normal)
        }
        button.tintColor = .systemBlue
        return button
    }()
    
    public let endCallButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let icon = UIImage(systemName: "phone.down.fill") {
            button.setImage(icon, for: .normal)
        }
        button.tintColor = .systemRed
        return button
    }()
    
    public let switchCameraButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let icon = UIImage(systemName: "camera.rotate.fill") {
            button.setImage(icon, for: .normal)
        }
        button.tintColor = .systemGreen
        return button
    }()
    
    public let timerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    public let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 28
        return stack
    }()
    
    private var gradientLayer: CAGradientLayer?
    private var timer: Timer?
    private var elapsedSeconds: Int = 0
    
    public var mute: (() -> Void)?
    public var endCall: (() -> Void)?
    public var camera: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setButtonActions()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setButtonActions()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let newGradient = CAGradientLayer()
        newGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        newGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        newGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        newGradient.frame = self.bounds
        newGradient.masksToBounds = true
        self.layer.insertSublayer(newGradient, at: 0)
        gradientLayer = newGradient
    }
    
    private func setupView() {
        addSubview(topStackView)
        addSubview(bottomStackView)
        addSubview(timerView)
        timerView.addSubview(timerLabel)
        topStackView.addArrangedSubview(clinicNameLabel)
        topStackView.addArrangedSubview(doctorInfoStackView)
        bottomStackView.addArrangedSubview(muteButton)
        bottomStackView.addArrangedSubview(endCallButton)
        bottomStackView.addArrangedSubview(switchCameraButton)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -45),
            bottomStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10),
            timerView.heightAnchor.constraint(equalToConstant: 30),
            timerView.widthAnchor.constraint(equalToConstant: 135),
            timerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
            timerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor)
        ])
        
        muteButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        muteButton.widthAnchor.constraint(equalTo: muteButton.heightAnchor).isActive = true
        
        endCallButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        endCallButton.widthAnchor.constraint(equalTo: endCallButton.heightAnchor).isActive = true
        
        switchCameraButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        switchCameraButton.widthAnchor.constraint(equalTo: switchCameraButton.heightAnchor).isActive = true
        
        dashLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setButtonActions() {
        self.muteButton.addTarget(self, action: #selector(handleMuteButton), for: .touchUpInside)
        self.endCallButton.addTarget(self, action: #selector(handleEndCallButton), for: .touchUpInside)
        self.switchCameraButton.addTarget(self, action: #selector(handleSwitchCameraButton), for: .touchUpInside)
    }
    
    public func configureInfo(clinicName: String?, doctorName: String?, doctorNumber: String?) {
        self.clinicNameLabel.text = nil
        if let dName = doctorName, !dName.isEmpty, let dNumber = doctorNumber, !dNumber.isEmpty {
            self.doctorNameLabel.text = dName
            self.doctorMCRLabel.text = dNumber
            self.dashLabel.isHidden = false
        } else {
            self.doctorNameLabel.text = doctorName ?? ""
            self.doctorMCRLabel.text = doctorNumber ?? ""
            self.dashLabel.isHidden = true
        }
    }
    
    public func setImage(for buttonType: ButtonType, with image: UIImage?) {
        switch buttonType {
        case .mute:
            let defaultImage = UIImage(systemName: "speaker.slash.fill")
            muteButton.setImage(image ?? defaultImage, for: .normal)
        case .endCall:
            let defaultImage = UIImage(systemName: "phone.down.fill")
            endCallButton.setImage(image ?? defaultImage, for: .normal)
        case .switchCamera:
            let defaultImage = UIImage(systemName: "camera.rotate.fill")
            switchCameraButton.setImage(image ?? defaultImage, for: .normal)
        }
    }
    
    public func startTimer() {
        timer?.invalidate()
        elapsedSeconds = 0
        timerLabel.text = "00:00"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimerLabel() {
        elapsedSeconds += 1
        if elapsedSeconds < 3600 {
            let minutes = elapsedSeconds / 60
            let seconds = elapsedSeconds % 60
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            let hours = elapsedSeconds / 3600
            let minutes = (elapsedSeconds % 3600) / 60
            let seconds = elapsedSeconds % 60
            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    @objc private func handleMuteButton() {
        PrettyLogger.info("Mute Button Tapped")
        mute?()
    }
    
    @objc private func handleEndCallButton() {
        PrettyLogger.info("End Call Button Tapped")
        endCall?()
    }
    
    @objc private func handleSwitchCameraButton() {
        PrettyLogger.info("Switch Camera Button Tapped")
        camera?()
    }
}
