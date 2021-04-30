//
//  DetailsBasic.swift
//  ArtistPodcast
//
//  Created by apple on 26.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsBasic: UIView {

    var editable: Bool = false {
        didSet {
        }
    }
    
    var placeholder: String = "" {
        didSet {
        }
    }
    
    var expanded: Bool = false {
        didSet {
            let icon: UIImage = getSVGImage(name: "down-arrow")
            let iconSelected: UIImage = getSVGImage(name: "up-arrow")

            if expanded {
                toggleButton.setImage(iconSelected, for: .normal)
                self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewExpandedHeight)
                self.layoutIfNeeded()
            } else {
                toggleButton.setImage(icon, for: .normal)
                self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewHeight)
                self.layoutIfNeeded()
            }
        }
    }
    
    var expandable: Bool = false {
        didSet {
            toggleButton.isHidden = !expandable
        }
    }
    var value: String = "" {
        didSet {
        }
    }

    var icon: String = "" {
        didSet {
            let image: UIImage = getSVGImage(name: self.icon)
            iconView.image = image
        }
    }

    var title: String = "" {
        didSet {
            mainLabel.text = title
        }
    }

    lazy var iconView: UIImageView = {
        let view: UIImageView = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var mainLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textColor = Theme.colorTextBase
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var toggleButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon: UIImage = getSVGImage(name: "down-arrow")
        let iconSelected: UIImage = getSVGImage(name: "up-arrow")
        button.setImage(icon, for: .normal)
        button.setImage(iconSelected, for: .highlighted)
        button.addTarget(self, action: #selector(self.toggleTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var container: UIView = {
        let view: UIView = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public
    public func initialize() {
        
        addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultNavButtonPadding),
            iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding),
            iconView.heightAnchor.constraint(equalToConstant: sizeDetailsViewIcon.height),
            iconView.widthAnchor.constraint(equalToConstant: sizeDetailsViewIcon.width),
        ])

        self.addSubview(toggleButton)
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            toggleButton.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding),
            toggleButton.heightAnchor.constraint(equalToConstant: iconButtonSize.height),
            toggleButton.widthAnchor.constraint(equalToConstant: iconButtonSize.width),
        ])

        self.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: defaultNavButtonPadding),
            mainLabel.trailingAnchor.constraint(equalTo: self.toggleButton.leadingAnchor, constant: defaultNavButtonPadding * (-1)),
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding),
        ])
        
        backgroundColor = Theme.sidemenuColor
        self.dropShadow(color: .black, offSet: CGSize(width: 3,height: 3))

    }
    
    //click handlers
    @objc func toggleTapped(_ sender: UIButton) {
        if expandable {
            toggleHandler(sender: sender)
        }
    }
    
    public func toggleHandler(sender: UIButton) {
        expanded = !expanded
    }
    

}
