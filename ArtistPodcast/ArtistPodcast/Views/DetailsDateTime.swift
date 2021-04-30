//
//  DetailsDateTime.swift
//  ArtistPodcast
//
//  Created by apple on 26.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsDateTime: DetailsBasic {
    
    var valueDate: String!
    var valueTime: String!

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
            valueDate = Helper.DateTimeFormat(date: value, format: "yyyy-MM-dd")
            valueTime = Helper.DateTimeFormat(date: value, format: "HH:mm:ss")
            let localDateString = Helper.DateTimeFormat(date: value, format: "MMM dd, yyyy")
            let localTimeString = Helper.DateTimeFormat(date: value, format: "h:mm a")
            dateTextField.text = localDateString
            timeTextField.text = localTimeString
            
            title = localDateString + " " + localTimeString
        }
    }
    
    //lazy vars
    lazy var dateStack:UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 2
        stack.distribution = .fill
        return stack
    }()
    
    lazy var timeStack:UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 2
        stack.distribution = .fill
        return stack
    }()
    
    lazy var dateLabel:UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.formPlaceholderColor
        label.textAlignment = .left
        label.text = "Date"
        label.backgroundColor = .clear
        return label
    }()

    lazy var timeLabel:UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.formPlaceholderColor
        label.textAlignment = .left
        label.text = "Time"
        label.backgroundColor = .clear
        return label
    }()

    lazy var dateTextField: UITextField = {
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

    lazy var timeTextField: UITextField = {
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
        initDatePickers()

    }
    
    private func initSubviews() {
        
        addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultNavButtonPadding),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            container.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: defaultNavButtonPadding),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        container.addSubview(dateStack)
        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: self.container.topAnchor),
            dateStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultNavButtonPadding),
            dateStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.4),
            dateStack.heightAnchor.constraint(equalToConstant: floatTimeStackHeight),
        ])
        dateStack.addArrangedSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])
        dateStack.addArrangedSubview(dateTextField)
        NSLayoutConstraint.activate([
            dateTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
        ])

        container.addSubview(timeStack)
        NSLayoutConstraint.activate([
            timeStack.topAnchor.constraint(equalTo: self.container.topAnchor),
            timeStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            timeStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.4),
            timeStack.heightAnchor.constraint(equalToConstant: floatTimeStackHeight),
        ])
        timeStack.addArrangedSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])
        timeStack.addArrangedSubview(timeTextField)
        NSLayoutConstraint.activate([
            timeTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
        ])
        
        container.isHidden = true

    }
    
    private func initDatePickers() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        timeTextField.inputView = timePicker

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view != dateTextField && touch.view != timeTextField {
            self.endEditing(true)
            dateTextField.resignFirstResponder()
            timeTextField.resignFirstResponder()
        }
    }
    
    override public func toggleHandler(sender: UIButton) {
        super.toggleHandler(sender: sender)
        dateTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()

    }


}

extension DetailsDateTime {
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        valueDate = formatter.string(from: datePicker.date)

        formatter.dateFormat = "MMM dd, yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)

        title = valueDate + " " + valueTime
    }

    @objc func timeChanged(_ datePicker: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        valueTime = formatter.string(from: datePicker.date)
        
        formatter.dateFormat = "hh:mm a"
        timeTextField.text = formatter.string(from: datePicker.date)
        
        title = valueDate + " " + valueTime

    }

}
