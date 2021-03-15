/*****************************************************************************
* SpoilerButton.swift
*
* Copyright © 2021 VLC authors and VideoLAN
*
* Authors: Edgar Fouillet <vlc # edgar.fouillet.eu>
*
* Refer to the COPYING file of the official project for license.
*****************************************************************************/

import UIKit

class SpoilerButton: UIView {
    // MARK: - Properties
    private let buttonStackView = UIStackView()
    private let openButton = UIButton()
    private let chevronImage = UIImageView(image: UIImage(named: "iconChevron")?.withRenderingMode(.alwaysTemplate))
    private var hiddenView: UIView? {
        didSet {
            setupViews()
        }
    }
    private var hiddenHeightConstraint: NSLayoutConstraint?
    private var shownHeightConstraint: NSLayoutConstraint?
    private var isOpened = false
    var parent: UIView?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup
    private func setupOpenButton() {
        openButton.addTarget(self, action: #selector(openButtonPressed), for: .touchUpInside)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.setContentHuggingPriority(.required, for: .vertical)
        openButton.setTitleColor(PresentationTheme.current.colors.orangeUI, for: .normal)
        openButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.tintColor = PresentationTheme.current.colors.orangeUI

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.alignment = .fill
        buttonStackView.addArrangedSubview(openButton)
        buttonStackView.addArrangedSubview(chevronImage)
    }

    private func setupViews() {
        if let hiddenView = hiddenView {
            setupOpenButton()
            hiddenView.translatesAutoresizingMaskIntoConstraints = false

            clipsToBounds = true
            translatesAutoresizingMaskIntoConstraints = false
            setContentHuggingPriority(.required, for: .vertical)

            addSubview(buttonStackView)
            addSubview(hiddenView)

            let newConstraints = [
                buttonStackView.topAnchor.constraint(equalTo: topAnchor),
                buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

                chevronImage.heightAnchor.constraint(equalTo: openButton.heightAnchor),
                chevronImage.widthAnchor.constraint(equalTo: chevronImage.heightAnchor),

                hiddenView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10),
                hiddenView.leadingAnchor.constraint(equalTo: leadingAnchor),
                hiddenView.trailingAnchor.constraint(equalTo: trailingAnchor),
                hiddenView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
            NSLayoutConstraint.activate(newConstraints)

            hiddenHeightConstraint = heightAnchor.constraint(equalTo: buttonStackView.heightAnchor)
            hiddenHeightConstraint?.isActive = true

            hiddenView.isHidden = true
        }
    }

    // MARK: - Handlers
    @objc private func openButtonPressed() {
        toggleHiddenView()
    }

    // MARK: - Public
    func setTitle(_ title: String) {
        openButton.setTitle(title, for: .normal)
    }

    func setHiddenView(with view: UIView) {
        hiddenView = view
    }

    func setHeightConstraint(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1.0) {
        shownHeightConstraint = heightAnchor.constraint(equalTo: anchor, multiplier: multiplier)
    }

    func toggleHiddenView() {
        isOpened = !isOpened

        UIView.animate(withDuration: 0.3, animations: {
            self.hiddenHeightConstraint?.isActive = !self.isOpened
            self.shownHeightConstraint?.isActive = self.isOpened
            self.hiddenView?.isHidden = !self.isOpened
            self.chevronImage.transform = CGAffineTransform(rotationAngle: self.isOpened ? .pi : 0)
            self.parent?.layoutIfNeeded()
            self.layoutIfNeeded()
        })
    }
}
