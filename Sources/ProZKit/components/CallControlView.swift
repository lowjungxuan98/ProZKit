//
//  CallControlView.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 18/2/25.
//

import UIKit

public class CallControlView: UIView {
    public let button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.addFontShadow()
        return label
    }()

    public lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [button, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()

    // MARK: - Stored Constraints for Updating Button Size

    private var buttonHeightConstraint: NSLayoutConstraint?
    private var buttonWidthConstraint: NSLayoutConstraint?

    public init(image: UIImage?, labelText: String, tintColor: UIColor, buttonSize: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        // Configure the button and label
        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        label.text = labelText

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Create and store size constraints for the button.
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: buttonSize)
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: buttonSize)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint])
        buttonHeightConstraint = heightConstraint
        buttonWidthConstraint = widthConstraint
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Update APIs

    /// Updates the button's size.
    public func updateButtonSize(_ size: CGFloat) {
        buttonHeightConstraint?.constant = size
        buttonWidthConstraint?.constant = size
        layoutIfNeeded()
    }

    /// Updates the label's text.
    public func updateLabelText(_ text: String) {
        label.text = text
    }

    /// (Optional) Updates the button's image.
    public func updateImage(_ image: UIImage?) {
        button.setImage(image, for: .normal)
    }
}
