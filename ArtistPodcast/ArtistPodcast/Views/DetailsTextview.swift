//
//  DetailsTextview.swift
//  ArtistPodcast
//
//  Created by apple on 26.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsTextview: DetailsBasic {

    override var value: String {
        didSet {
            valueTextView.text = value
            coundownLabel.text = "\(valueTextView.text!.count)/\(s_DESCRIPTION_LIMIT)"
        }
    }
    
    override var expanded: Bool {
        didSet {
            let icon: UIImage = getSVGImage(name: "down-arrow")
            let iconSelected: UIImage = getSVGImage(name: "up-arrow")

            valueTextView.isHidden = !expanded
            print(expanded)
            print(valueTextView.isHidden)
            if editable {
                coundownLabel.isHidden = !expanded
                if expanded {
                    toggleButton.setImage(iconSelected, for: .normal)
                    self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewExpandedTextViewHeight)
                    self.layoutIfNeeded()
                } else {
                    toggleButton.setImage(icon, for: .normal)
                    self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: floatDetailsViewHeight)
                    self.layoutIfNeeded()
                }
            }
        }
    }


    lazy var valueTextView: UITextView = {
        let tview: UITextView = UITextView(frame: .zero)
        tview.translatesAutoresizingMaskIntoConstraints = false
        tview.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        tview.textColor = Theme.formPlaceholderColor
        tview.isScrollEnabled = true
        tview.isEditable = false
        tview.isSelectable = false
        tview.layer.cornerRadius = 5
        tview.backgroundColor = .clear
        return tview
    }()
    
    lazy var coundownLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textColor = Theme.colorTextBase
        label.textAlignment = .right
        label.backgroundColor = .clear
        return label
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
        
        addSubview(valueTextView)
        valueTextView.backgroundColor = editable ? Theme.formTextfieldBackground : .clear
        NSLayoutConstraint.activate([
            valueTextView.leadingAnchor.constraint(equalTo: self.iconView.leadingAnchor, constant: defaultNavButtonPadding),
            valueTextView.trailingAnchor.constraint(equalTo: self.toggleButton.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
            valueTextView.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: defaultNavButtonPadding),
            valueTextView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        addSubview(coundownLabel)
        NSLayoutConstraint.activate([
            coundownLabel.trailingAnchor.constraint(equalTo: self.valueTextView.trailingAnchor),
            coundownLabel.topAnchor.constraint(equalTo: self.valueTextView.bottomAnchor, constant: defaultNavButtonPadding / 2),
            coundownLabel.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
            coundownLabel.widthAnchor.constraint(equalToConstant: 120)
        ])

        valueTextView.isHidden = true
        coundownLabel.text = "0/\(s_DESCRIPTION_LIMIT)"
        coundownLabel.isHidden = true
        
        if editable {
            valueTextView.delegate = self
            valueTextView.isEditable = true
            valueTextView.isSelectable = true
        }
        
        backgroundColor = Theme.sidemenuColor

//        self.dropShadow(color: .black, offSet: CGSize(width: 3,height: 3))

    }
    
    override public func toggleHandler(sender: UIButton) {
        super.toggleHandler(sender: sender)
        if expanded {
            title = placeholder
        } else {
            value = valueTextView.text!
        }
        self.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view != valueTextView {
            self.endEditing(true)
        }
    }


}

extension DetailsTextview: UITextViewDelegate {
    //text view delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        self.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            //textView.placeholder = textViewTitle
        } else {
            //textView.placeholder = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars > s_DESCRIPTION_LIMIT {
            coundownLabel.text = "\(numberOfChars)/\(s_DESCRIPTION_LIMIT)"
            textView.resignFirstResponder()
            return false
        }
        coundownLabel.text = "\(numberOfChars)/\(s_DESCRIPTION_LIMIT)"
        return true
    }

}
