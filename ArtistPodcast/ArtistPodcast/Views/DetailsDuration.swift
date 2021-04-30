//
//  DetailsDuration.swift
//  ArtistPodcast
//
//  Created by apple on 27.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsDuration: DetailsBasic {
    
    let image: UIImage = UIImage(named: "radio")!
    let imageSelected: UIImage = UIImage(named: "radio-pressed")!
    
    override var expanded: Bool {
        didSet {
            if editable {
                container.isHidden = !expanded
                if expanded {
                    toggleButton.setImage(getSVGImage(name: "up-arrow"), for: .normal)
                    self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewExpandedHeight)
                    self.layoutIfNeeded()
                } else {
                    toggleButton.setImage(getSVGImage(name: "down-arrow"), for: .normal)
                    self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewHeight)
                    self.layoutIfNeeded()
                }
            }
        }
    }

    override var value: String {
        didSet {
            buttonLess.isSelected = false
            buttonMiddle.isSelected = false
            buttonMore.isSelected = false
            if value == "00:30" {
                buttonLess.isSelected = true
                title = "< 30 minutes"
            } else if value == "00:60" {
                buttonMiddle.isSelected = true
                title = "30-90 minutes"
            } else if value == "00:90" {
                buttonMore.isSelected = true
                title = "90+ minutes"
            }
        }
    }


    //lazy vars
    lazy var buttonLess: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 30
        button.addTarget(self, action: #selector(self.selectionTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.title(title: "< 30")
        button.leftImagePadding(image: image, imagePressed: imageSelected, padding: 5)
        return button
    }()

    lazy var buttonMiddle: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 60
        button.addTarget(self, action: #selector(self.selectionTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.title(title: "30-90")
        button.leftImagePadding(image: image, imagePressed: imageSelected, padding: 5)
        return button
    }()

    lazy var buttonMore: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 90
        button.addTarget(self, action: #selector(self.selectionTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.leftImagePadding(image: image, imagePressed: imageSelected, padding: 5)
        button.title(title: "90+")
        return button
    }()

    lazy var label: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.formPlaceholderColor
        label.textAlignment = .center
        label.text = "Select the approximate show length (in minutes)"
        label.backgroundColor = .clear
        return label
    }()

    //init
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public
    override public func initialize() {
        super.initialize()
        
        initSubviews()

    }
    
    //private ui
    private func initSubviews() {
        
        addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultNavButtonPadding),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            container.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: defaultNavButtonPadding),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: defaultNavButtonPadding),
            label.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            label.topAnchor.constraint(equalTo: self.container.topAnchor, constant: defaultNavButtonPadding / 3),
            label.heightAnchor.constraint(equalToConstant: floatLabelHeight)
        ])
        
        container.addSubview(buttonMiddle)
        NSLayoutConstraint.activate([
            buttonMiddle.centerXAnchor.constraint(equalTo: self.container.centerXAnchor),
            buttonMiddle.topAnchor.constraint(equalTo: label.bottomAnchor, constant: defaultNavButtonPadding / 3),
            buttonMiddle.heightAnchor.constraint(equalToConstant: sizeDurationButton.height),
            buttonMiddle.widthAnchor.constraint(equalToConstant: sizeDurationButton.width)
        ])

        container.addSubview(buttonLess)
        NSLayoutConstraint.activate([
            buttonLess.trailingAnchor.constraint(equalTo: buttonMiddle.leadingAnchor, constant: floatFormPadding / 2 * (-1)),
            buttonLess.topAnchor.constraint(equalTo: label.bottomAnchor, constant: defaultNavButtonPadding / 3),
            buttonLess.heightAnchor.constraint(equalToConstant: sizeDurationButton.height),
            buttonLess.widthAnchor.constraint(equalToConstant: sizeDurationButton.width)
        ])

        container.addSubview(buttonMore)
        NSLayoutConstraint.activate([
            buttonMore.leadingAnchor.constraint(equalTo: buttonMiddle.trailingAnchor, constant: floatFormPadding / 2),
            buttonMore.topAnchor.constraint(equalTo: label.bottomAnchor, constant: defaultNavButtonPadding / 3),
            buttonMore.heightAnchor.constraint(equalToConstant: sizeDurationButton.height),
            buttonMore.widthAnchor.constraint(equalToConstant: sizeDurationButton.width)
        ])
        
        container.isHidden = true
    }


    //click handlers
    @objc func selectionTapped(_ sender: UIButton) {
        value = "00:\(sender.tag)"
    }
    
}
