//
//  BroadcastPlayView.swift
//  ArtistPodcast
//
//  Created by apple on 22.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class BroadcastPlayView: UIView {
    
    //vars
    var remaining: String = "" {
        didSet {
            remainLabel.text = remaining
        }
    }
    
    //lazy UI vars
    lazy var remainLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = Theme.formPlaceholderColor
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var soundcheckButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon: UIImage = getSVGImage(name: "soundcheck-pressed")
        let iconSelected: UIImage = getSVGImage(name: "soundcheck-pressed")
        button.setImage(icon, for: .normal)
        button.setImage(iconSelected, for: .selected)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.soundcheckTapped(_:)), for: .touchUpInside)
        return button
    }()

    lazy var livestreamButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon: UIImage = getSVGImage(name: "broadcast-pressed")
        let iconSelected: UIImage = getSVGImage(name: "broadcast-pressed")
        button.setImage(icon, for: .normal)
        button.setImage(iconSelected, for: .selected)
        button.addTarget(self, action: #selector(self.livestreamTapped(_:)), for: .touchUpInside)
        return button
    }()

    //init
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public
    public func initialize() {
        addSubview(remainLabel)
        NSLayoutConstraint.activate([
            remainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            remainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            remainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding / 2),
            remainLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])
        
        let stack1: UIStackView = getStack()
        addSubview(stack1)
        NSLayoutConstraint.activate([
            stack1.topAnchor.constraint(equalTo: self.remainLabel.bottomAnchor, constant: defaultNavButtonPadding / 2),
            stack1.centerXAnchor.constraint(equalTo: centerXAnchor, constant: (sizeBroadcastButton.width / 2 + defaultNavButtonPadding) * (-1)),
            stack1.widthAnchor.constraint(equalToConstant: sizeBroadcastButton.width),
            stack1.heightAnchor.constraint(equalToConstant: sizeBroadcastButton.height + floatLabelHeight),
        ])
        stack1.addArrangedSubview(soundcheckButton)
        NSLayoutConstraint.activate([
            soundcheckButton.centerXAnchor.constraint(equalTo: stack1.centerXAnchor),
            soundcheckButton.widthAnchor.constraint(equalToConstant: sizeBroadcastButton.width),
            soundcheckButton.heightAnchor.constraint(equalToConstant: sizeBroadcastButton.height),
        ])
        let label1: UILabel = getLabel()
        label1.text = "Soundcheck"
        stack1.addArrangedSubview(label1)
        NSLayoutConstraint.activate([
            label1.leadingAnchor.constraint(equalTo: stack1.leadingAnchor),
            label1.trailingAnchor.constraint(equalTo: stack1.trailingAnchor),
            label1.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])
        
        let stack2: UIStackView = getStack()
        addSubview(stack2)
        NSLayoutConstraint.activate([
            stack2.topAnchor.constraint(equalTo: self.remainLabel.bottomAnchor, constant: defaultNavButtonPadding / 2),
            stack2.centerXAnchor.constraint(equalTo: centerXAnchor, constant: (sizeBroadcastButton.width / 2 + defaultNavButtonPadding)),
            stack2.widthAnchor.constraint(equalToConstant: sizeBroadcastButton.width),
            stack2.heightAnchor.constraint(equalToConstant: sizeBroadcastButton.height + floatLabelHeight),
        ])
        stack2.addArrangedSubview(livestreamButton)
        NSLayoutConstraint.activate([
            livestreamButton.centerXAnchor.constraint(equalTo: stack2.centerXAnchor),
            livestreamButton.widthAnchor.constraint(equalToConstant: sizeBroadcastButton.width),
            livestreamButton.heightAnchor.constraint(equalToConstant: sizeBroadcastButton.height),
        ])
        let label2: UILabel = getLabel()
        label2.text = "Live stream"
        stack2.addArrangedSubview(label2)
        NSLayoutConstraint.activate([
            label2.widthAnchor.constraint(equalTo: stack2.widthAnchor),
            label2.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])

        backgroundColor = .clear
    }
    
    private func getStack() ->UIStackView {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }
    
    private func getLabel() ->UILabel {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = Theme.colorTextBase
        label.backgroundColor = .clear
        return label
    }
    
    //click handlers
    @objc public func soundcheckTapped(_ sender: UIButton) {
        print("soundcheck")
    }
    @objc public func livestreamTapped(_ sender: UIButton) {
        print("livestream")
    }

}
