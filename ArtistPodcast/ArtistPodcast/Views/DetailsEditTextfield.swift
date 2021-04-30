//
//  DetailsEditTextfield.swift
//  ArtistPodcast
//
//  Created by apple on 26.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsEditTextfield: DetailsBasic {

    override var expanded: Bool {
        didSet {
            valueTextField.isHidden = !expanded
            if editable {
                if expanded {
                    toggleButton.setImage(getSVGImage(name: "up-arrow"), for: .normal)
                    self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewExpandedTextFieldHeight)
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
            valueTextField.text = value
        }
    }

    lazy var valueTextField: UITextField = {
        let tfield: UITextField = UITextField(frame: .zero)
        tfield.translatesAutoresizingMaskIntoConstraints = false
        tfield.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        tfield.textColor = Theme.formPlaceholderColor
        tfield.layer.cornerRadius = 5
        tfield.setLeftPaddingPoints(10)
        tfield.setRightPaddingPoints(10)

        return tfield
    }()


    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public
    override public func initialize() {
        
        super.initialize()
        
        addSubview(valueTextField)
        NSLayoutConstraint.activate([
            valueTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultNavButtonPadding),
            valueTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            valueTextField.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: defaultNavButtonPadding),
            valueTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight)
        ])
        valueTextField.isHidden = true
        valueTextField.backgroundColor = editable ? Theme.formTextfieldBackground : .clear
        if editable {
            valueTextField.delegate = self
        }

        backgroundColor = Theme.sidemenuColor

//        self.dropShadow(color: .black, offSet: CGSize(width: 3,height: 3))

    }
    
    //click handlers
    override public func toggleHandler(sender: UIButton) {
        super.toggleHandler(sender: sender)
        if expanded {
            title = placeholder
        } else {
            value = valueTextField.text!
            title = value
        }
        self.endEditing(true)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view != valueTextField {
            self.endEditing(true)
        }
    }

}

extension DetailsEditTextfield: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("change")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.endEditing(true)
        return false
    }
}
