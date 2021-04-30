//
//  TopBar.swift
//  ArtistPodcast
//
//  Created by apple on 19.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

protocol TopBarDelegate: class {
    func leftClicked()
    func rightClicked()
}

class TopBar: UIView {
    
    var delegate: TopBarDelegate?

    lazy var leftButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.leftButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.rightButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.colorHeaderTitle
        return label
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setRightButton(image: UIImage? = UIImage(), title: String? = String(), size: CGSize? = defaultNavButtonSize) {
        rightButton.title(title: title)
        if title != "" {
            rightButton.leftImage(image: image!)
        } else {
            rightButton.imageOnly(image: image!)
        }
        addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            rightButton.heightAnchor.constraint(equalToConstant: size!.height),
            rightButton.widthAnchor.constraint(equalToConstant: size!.width),
        ])
    }

    public func setLeftButton(image: UIImage? = UIImage(), title: String? = String(), size: CGSize? = defaultNavButtonSize) {
        leftButton.title(title: title)
        if title != "" {
            leftButton.leftImage(image: image!)
        } else {
            leftButton.imageOnly(image: image!)
        }
        addSubview(leftButton)
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultNavButtonPadding),
            leftButton.heightAnchor.constraint(equalToConstant: size!.height),
            leftButton.widthAnchor.constraint(equalToConstant: size!.width),
        ])
    }
    
    public func setTitleLabel(title: String? = "") {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        titleLabel.text = title
    }

    //click handlers
    @objc public func leftButtonTapped(_ sender: UIButton) {
        delegate?.leftClicked()
    }

    @objc public func rightButtonTapped(_ sender: UIButton) {
        delegate?.rightClicked()
    }

}
