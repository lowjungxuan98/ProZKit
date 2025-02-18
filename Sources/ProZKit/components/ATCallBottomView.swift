//
//  ATCallBottomView.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 14/2/25.

import UIKit

public class ATCallBottomView: UIView {
    
    // MARK: - Top Labels & Info
    
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
    
    // MARK: - Call Control Views
    
    public lazy var muteControl: CallControlView = {
        let image = UIImage(systemName: "speaker.slash.fill")
        return CallControlView(image: image, labelText: "Mute", tintColor: .systemBlue, buttonSize: 55)
    }()
    
    public lazy var endCallControl: CallControlView = {
        let image = UIImage(systemName: "phone.down.fill")
        return CallControlView(image: image, labelText: "End Call", tintColor: .systemRed, buttonSize: 70)
    }()
    
    public lazy var switchCameraControl: CallControlView = {
        let image = UIImage(systemName: "camera.rotate.fill")
        return CallControlView(image: image, labelText: "Switch Camera", tintColor: .systemGreen, buttonSize: 55)
    }()
    
    // MARK: - Timer View
    
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
    
    // MARK: - Container Stack Views
    
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
        stack.distribution = .fillEqually
        stack.spacing = 28
        return stack
    }()
    
    // MARK: - Properties
    
    private var gradientLayer: CAGradientLayer?
    private var timer: Timer?
    private var elapsedSeconds: Int = 0
    
    public var mute: (() -> Void)?
    public var endCall: (() -> Void)?
    public var camera: (() -> Void)?
    
    // MARK: - Initialization
    
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
    
    // MARK: - Layout
    
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
    
    // MARK: - Setup Methods
    
    private func setupView() {
        addSubview(topStackView)
        addSubview(bottomStackView)
        addSubview(timerView)
        timerView.addSubview(timerLabel)
        
        topStackView.addArrangedSubview(clinicNameLabel)
        topStackView.addArrangedSubview(doctorInfoStackView)
        
        bottomStackView.addArrangedSubview(muteControl)
        bottomStackView.addArrangedSubview(endCallControl)
        bottomStackView.addArrangedSubview(switchCameraControl)
        
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
        
        dashLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setButtonActions() {
        muteControl.button.addTarget(self, action: #selector(handleMuteButton), for: .touchUpInside)
        endCallControl.button.addTarget(self, action: #selector(handleEndCallButton), for: .touchUpInside)
        switchCameraControl.button.addTarget(self, action: #selector(handleSwitchCameraButton), for: .touchUpInside)
    }
    
    // MARK: - Public Methods
    
    public func configureInfo(clinicName: String?, doctorName: String?, doctorNumber: String?) {
        clinicNameLabel.text = clinicName
        if let dName = doctorName, !dName.isEmpty,
           let dNumber = doctorNumber, !dNumber.isEmpty {
            doctorNameLabel.text = dName
            doctorMCRLabel.text = dNumber
            dashLabel.isHidden = false
        } else {
            doctorNameLabel.text = doctorName ?? ""
            doctorMCRLabel.text = doctorNumber ?? ""
            dashLabel.isHidden = true
        }
    }
    
    public func setImage(for buttonType: ButtonType, with image: UIImage?) {
        switch buttonType {
        case .mute:
            let defaultImage = UIImage(systemName: "speaker.slash.fill")
            muteControl.button.setImage(image ?? defaultImage, for: .normal)
        case .endCall:
            let defaultImage = UIImage(systemName: "phone.down.fill")
            endCallControl.button.setImage(image ?? defaultImage, for: .normal)
        case .switchCamera:
            let defaultImage = UIImage(systemName: "camera.rotate.fill")
            switchCameraControl.button.setImage(image ?? defaultImage, for: .normal)
        }
    }
    
    /// Updates the button size for the specified control.
    public func setSize(for buttonType: ButtonType, buttonSize: CGFloat) {
        switch buttonType {
        case .mute:
            muteControl.updateButtonSize(buttonSize)
        case .endCall:
            endCallControl.updateButtonSize(buttonSize)
        case .switchCamera:
            switchCameraControl.updateButtonSize(buttonSize)
        }
    }
    
    /// Updates the label text for the specified control.
    public func setText(for buttonType: ButtonType, labelText: String) {
        switch buttonType {
        case .mute:
            muteControl.updateLabelText(labelText)
        case .endCall:
            endCallControl.updateLabelText(labelText)
        case .switchCamera:
            switchCameraControl.updateLabelText(labelText)
        }
    }
    
    public func startTimer() {
        timer?.invalidate()
        elapsedSeconds = 0
        timerLabel.text = "00:00"
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimerLabel),
            userInfo: nil,
            repeats: true
        )
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private Methods
    
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
    
    public func setViewController(_ viewController: UIViewController, safeArea: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(self)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        if safeArea {
            bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        }
    }
}
