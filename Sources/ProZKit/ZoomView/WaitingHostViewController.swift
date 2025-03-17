//
//  WaitingHostViewController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 13/3/25.
//

import MobileRTC
import UIKit

class WaitingHostViewController: UIViewController {
    // UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Waiting Host for start meeting..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // New Quit Button
    private lazy var quitButton: UIButton = {
        let button: UIButton
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.title = "Quit Waiting"
            configuration.baseBackgroundColor = .red
            configuration.baseForegroundColor = .white
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            button = UIButton(configuration: configuration, primaryAction: nil)
            // Adjust corner radius if desired (this may be overridden by the configuration, so test as needed)
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        } else {
            // Fallback on earlier versions
            button = UIButton(type: .system)
            button.setTitle("Quit Waiting", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitWaiting), for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(quitButton)

        NSLayoutConstraint.activate([
            // Logo ImageView constraints
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            // Title Label constraints
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Description Label constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Quit Button constraints
            quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            quitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    // MARK: - Configuration

    /// Configures the UI with custom waiting room data.
    func configure(with data: MobileRTCCustomWaitingRoomData) {
        titleLabel.text = data.title
        descriptionLabel.text = data.descriptionString

        // If a logo path is provided, attempt to load the image.
        if let logoPath = data.logoPath, let url = URL(string: logoPath) {
            // For simplicity, we load the image synchronously.
            // In production, consider using asynchronous image loading.
            if let imageData = try? Data(contentsOf: url) {
                logoImageView.image = UIImage(data: imageData)
            }
        }
    }

    // MARK: - Actions

    @objc private func quitWaiting() {
        MobileRTC.shared().getMeetingService()?.leaveMeeting(with: .leave)
        dismiss(animated: true)
    }
}
