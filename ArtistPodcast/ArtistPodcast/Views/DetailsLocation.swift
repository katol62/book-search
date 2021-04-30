//
//  DetailsLocation.swift
//  ArtistPodcast
//
//  Created by apple on 27.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsLocation: DetailsBasic {

    var states: [StateObject]!
    var zones: [ZoneObject]!
    
    var statesPicker : UIPickerView!
    var zonesPicker : UIPickerView!

    
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
        }
    }

    //lazy vars
    lazy var stateStack:UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 2
        stack.distribution = .fill
        return stack
    }()
    
    lazy var zoneStack:UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 2
        stack.distribution = .fill
        return stack
    }()
    
    lazy var statesLabel:UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.formPlaceholderColor
        label.textAlignment = .left
        label.text = "Select location"
        label.backgroundColor = .clear
        return label
    }()

    lazy var zoneLabel:UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.formPlaceholderColor
        label.textAlignment = .left
        label.text = "Select timezone"
        label.backgroundColor = .clear
        return label
    }()

    lazy var stateTextField: UITextField = {
        let tfield: UITextField = UITextField(frame: .zero)
        tfield.translatesAutoresizingMaskIntoConstraints = false
        tfield.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        tfield.textColor = Theme.formPlaceholderColor
        tfield.backgroundColor = Theme.formTextfieldBackground
        tfield.layer.cornerRadius = 5
        tfield.setLeftPaddingPoints(10)
        tfield.setRightPaddingPoints(10)
        tfield.isUserInteractionEnabled = true
        return tfield
    }()

    lazy var zoneTextField: UITextField = {
        let tfield: UITextField = UITextField(frame: .zero)
        tfield.translatesAutoresizingMaskIntoConstraints = false
        tfield.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        tfield.textColor = Theme.formPlaceholderColor
        tfield.layer.cornerRadius = 5
        tfield.backgroundColor = Theme.formTextfieldBackground
        tfield.setLeftPaddingPoints(10)
        tfield.setRightPaddingPoints(10)
        tfield.isUserInteractionEnabled = true
        return tfield
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

        container.addSubview(stateStack)
        NSLayoutConstraint.activate([
            stateStack.topAnchor.constraint(equalTo: self.container.topAnchor),
            stateStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultNavButtonPadding),
            stateStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.4),
            stateStack.heightAnchor.constraint(equalToConstant: floatTimeStackHeight),
        ])
        stateStack.addArrangedSubview(statesLabel)
        NSLayoutConstraint.activate([
            statesLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])
        stateStack.addArrangedSubview(stateTextField)
        NSLayoutConstraint.activate([
            stateTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
        ])

        container.addSubview(zoneStack)
        NSLayoutConstraint.activate([
            zoneStack.topAnchor.constraint(equalTo: self.container.topAnchor),
            zoneStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            zoneStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.4),
            zoneStack.heightAnchor.constraint(equalToConstant: floatTimeStackHeight),
        ])
        zoneStack.addArrangedSubview(zoneLabel)
        NSLayoutConstraint.activate([
            zoneLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])
        zoneStack.addArrangedSubview(zoneTextField)
        NSLayoutConstraint.activate([
            zoneTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
        ])
        
        container.isHidden = true

    }

}

extension DetailsLocation: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case statesPicker:
                return states.count
            case zonesPicker:
                return zones.count
            default:
                return 0
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            case statesPicker:
                return states[row].state_name
            case zonesPicker:
                return zones[row].state_abbr
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            case statesPicker:
                break
            case zonesPicker:
                break
            default:
                break
        }
    }

    
}
