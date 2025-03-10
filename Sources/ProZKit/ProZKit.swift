// The Swift Programming Language
// https://docs.swift.org/swift-book
// import UIKit
//
// public class ATCallBottomView: UIView {
//
//    // Top Stack View Components
//    public let clinicNameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Clinic Name"
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 20)
//        return label
//    }()
//
//    public let doctorInfoLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Doctor MCR number and Doctor Name"
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 15)
//        return label
//    }()
//
//    // Bottom Stack View Buttons
//    public let muteButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    public let endCallButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    public let switchCameraButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    // Timer View Components
//    public let timerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 15
//        return view
//    }()
//
//    public let timerLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 20)
//        label.textAlignment = .center
//        label.text = "00:00"
//        return label
//    }()
//
//    // Stack Views
//    private let topStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.alignment = .center
//        stack.spacing = 4
//        return stack
//    }()
//
//    private let bottomStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.spacing = 28
//        return stack
//    }()
//
//    // Initialization
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
//
//    // Setup Layout
//    private func setupView() {
//        addSubview(topStackView)
//        addSubview(bottomStackView)
//        addSubview(timerView)
//
//        // Add Timer Label to Timer View
//        timerView.addSubview(timerLabel)
//
//        // Add Labels to Top Stack View
//        topStackView.addArrangedSubview(clinicNameLabel)
//        topStackView.addArrangedSubview(doctorInfoLabel)
//
//        // Add Buttons to Bottom Stack View
//        bottomStackView.addArrangedSubview(muteButton)
//        bottomStackView.addArrangedSubview(endCallButton)
//        bottomStackView.addArrangedSubview(switchCameraButton)
//
//        // Activate Auto Layout constraints
//        NSLayoutConstraint.activate([
//            // Top Stack View
//            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            topStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//
//            // Bottom Stack View
//            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -45),
//            bottomStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            topStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10),
//
//            // Timer View
//            timerView.heightAnchor.constraint(equalToConstant: 30),
//            timerView.widthAnchor.constraint(equalToConstant: 135),
//            timerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
//            timerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//
//            // Timer Label
//            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
//            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor)
//        ])
//
//        // Button Dimensions
//        muteButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
//        muteButton.widthAnchor.constraint(equalTo: muteButton.heightAnchor).isActive = true
//
//        endCallButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        endCallButton.widthAnchor.constraint(equalTo: endCallButton.heightAnchor).isActive = true
//
//        switchCameraButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
//        switchCameraButton.widthAnchor.constraint(equalTo: switchCameraButton.heightAnchor).isActive = true
//    }
// }
