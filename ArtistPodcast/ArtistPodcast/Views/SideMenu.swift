//
//  SideMenu.swift
//  ArtistPodcast
//
//  Created by apple on 20.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import SVGKit

class UIActionButton: UIButton {
    private var _action: Action = Action.none
    public var action: Action {
        get {
            return _action
        }
        set(value) {
            _action = value
        }
    }
}

protocol SideMenuDelegate: class {
    func onMenuClosed(action: Action)
}

class SideMenu: UIView {
    
    var state: MenuState = MenuState.hidden
    var selectedItem: Int = -1
    var animating: Bool = false

    var delegate: SideMenuDelegate?

    lazy var logo: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "logo-side")
        imageView.image = image
        return imageView
    }()
    
    lazy var logoutButton: UIActionButton = {
        let logoutButton = UIActionButton(type: .custom)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.action = Action.logout
        let icon = getSVGImage(name: "logout")
        let iconColored = changeTintColorWithImage(img: icon, tintColor: Theme.colorTextBase)
        let iconPressed = getSVGImage(name: "logout-pressed")
        let iconPressedColored = changeTintColorWithImage(img: iconPressed, tintColor: Theme.colorTextBase)
        logoutButton.title(title: "LOGOUT")
        logoutButton.leftImagePadding(image: iconColored, imagePressed: iconPressedColored, padding: defaultNavButtonPadding)
//        logoutButton.setImage(iconColored, for: .normal)
//        logoutButton.setImage(iconPressedColored, for: .selected)
        logoutButton.addTarget(self, action: #selector(self.logoutTapped(_:)), for: .touchUpInside)
        return logoutButton
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let icon = getSVGImage(name: "cancel")
        let iconColored = changeTintColorWithImage(img: icon, tintColor: Theme.colorTextBase)
        let iconPressed = getSVGImage(name: "cancel-pressed")
        let iconPressedColored = changeTintColorWithImage(img: iconPressed, tintColor: Theme.colorTextBase)
        closeButton.setImage(iconColored, for: .normal)
        closeButton.setImage(iconPressedColored, for: .selected)
        closeButton.addTarget(self, action: #selector(self.closeTapped(_:)), for: .touchUpInside)
        return closeButton
    }()

    lazy var stack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initMenu(items: Array<Any>) {
        self.initSideMenu(items: items)
    }
    
    private func initSideMenu(items: Array<Any>) {
        addSubview(logo)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding),
            logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: sidemenuLogoSize.height),
            logo.widthAnchor.constraint(equalToConstant: sidemenuLogoSize.width),
        ])

        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  defaultNavButtonPadding * (-1)),
            closeButton.widthAnchor.constraint(equalToConstant: iconButtonSize.width),
            closeButton.heightAnchor.constraint(equalToConstant: iconButtonSize.height),
        ])

        let menuItems = NSMutableArray(array: items)
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: loginFormPadding),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: (menuButtonSize.height + 2) * CGFloat(menuItems.count)),
        ])
        
        var tag = 0
        
        for item in menuItems {
            let arr = item as! NSArray
            let title = arr[0] as! String
            let image = arr[1] as! String
            let imagePressed = arr[2] as! String
            let action = arr[3] as! Action
            let icon = getSVGImage(name: image)
            let iconPressed = getSVGImage(name: imagePressed)
            let button = UIActionButton(type: .custom)
            button.action = action
            button.frame = .zero
            button.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                button.widthAnchor.constraint(equalToConstant: menuButtonSize.width),
                button.heightAnchor.constraint(equalToConstant: menuButtonSize.height),
            ])
            button.title(title: title)
            button.leftImagePadding(image: icon, imagePressed: iconPressed, padding: defaultNavButtonPadding)
            button.tag = tag + 100
            let bgImage: UIImage = UIImage.gradientImageWithBounds(bounds: button.bounds, colors: [Theme.colorMenuSelected, Theme.colorMenuSelectedTransparent], orientation: .horizontal)
            button.setBackgroundImage(bgImage, for: .selected)
            if tag == selectedItem {
                button.isSelected = true
            }
            button.addTarget(self, action: #selector(self.menuTapped(_:)), for: .touchUpInside)

            tag += 1
        }
        
        addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: (menuButtonSize.height + defaultNavButtonPadding) * (-1)),
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultNavButtonPadding),
            logoutButton.heightAnchor.constraint(equalToConstant: menuButtonSize.height),
            logoutButton.widthAnchor.constraint(equalToConstant: menuButtonSize.width),
        ])

        self.transform = CGAffineTransform(translationX: -floatSideMenuWidth, y: 0)
        if state == MenuState.hidden {
            self.isHidden = true
        }


    }
    //open close
    public func toggleMenu() {
        if animating {return}
        if state == MenuState.hidden {
            openMenu()
        } else {
            closeMenu()
        }
    }
    
    public func openMenu() {
        if animating {return}

        self.isHidden = true
        self.transform = CGAffineTransform(translationX: -floatSideMenuWidth, y: 0)
        self.isHidden = false
        animating = true
        UIView.animate(withDuration: TimeInterval(menuAnimateDuration), delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            self.state = MenuState.shown
            self.animating = false
        }
    }
    
    public func closeMenu(action: Action? = Action.none) {
        if animating {return}
        if state == MenuState.shown {
            self.isHidden = false
            animating = true
            self.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: TimeInterval(menuAnimateDuration), delay: 0.0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: -floatSideMenuWidth, y: 0)
            }) { _ in
                self.state = MenuState.hidden
                self.animating = false
                self.onMenuClosed(action: action!)
            }
        }
    }
    
    private func onMenuClosed(action: Action) {
        delegate?.onMenuClosed(action: action)
    }


    //click handlers
    @objc public func closeTapped(_ sender: UIButton) {
        toggleMenu()
    }

    @objc public func logoutTapped(_ sender: UIActionButton) {
        delegate?.onMenuClosed(action: sender.action)
    }

    @objc public func menuTapped(_ sender: UIActionButton) {
        print(sender.tag)
        closeMenu(action: sender.action)
    }


}
