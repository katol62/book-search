//
//  ShowDetailView.swift
//  PodcastArtist
//
//  Created by apple on 12.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

protocol ShowDetailViewDelegate: class {
    func updateInternalHeight(height: CGFloat)
}

class ShowDetailView: UIView {

    var expanded: Bool = false
    
    var delegate: ShowDetailViewDelegate?
    
    fileprivate var expandedHeightConstraint: NSLayoutConstraint?

    var details : Element? {
        didSet {
//            self.update(details: details!)
        }
    }
    
    var size: CGRect!
    
    init(frame: CGRect, details: Element) {
        super.init(frame: frame)
        self.size = frame
        self.details = details
        self.initialize()
    }
    
//    override init(frame rect: CGRect) {
//        super.init(frame: rect)
//        self.initialize()
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        print ("did layout")
        addTopBorderWithColor(color: sidemenuColor, width: 1)
        addBottomBorderWithColor(color: sidemenuColor, width: 1)
        dropShadow()

    }
    
    private var _value: String! = String()
    
    public var value: String {
        get {
            return _value
        }
        set(val) {
            _value = val
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var expandButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var expandedView : UIView = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var textField : UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = formTextfieldBackground
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    func initialize() {
        addSubview(button)
        
        addSubview(expandedView)
        expandedView.addSubview(textField)
        
        self.update(details: self.details!)
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        expandedHeightConstraint = self.expandedView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            expandedView.topAnchor.constraint(equalTo: button.bottomAnchor),
            expandedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            expandedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            expandedHeightConstraint!
        ])
        
    }
    
    func update(details: Element) {
                
        let icon = getSVGImage(name: details.image)
        button.leftImagePadding(image: icon, imagePressed: icon, padding: 10)
        button.title(title: details.title)
        button.addTarget(self, action: #selector(self.expandClick(_:)), for: .touchUpInside)

        self.backgroundColor = colorBackground

        setupConstraints()

        self.backgroundColor = .red
        button.backgroundColor = .cyan
        
        expandedView.backgroundColor = .yellow
        
        addTopBorderWithColor(color: sidemenuColor, width: 1)
        addBottomBorderWithColor(color: sidemenuColor, width: 1)
        dropShadow()

    }
    
    @objc public func expandClick(_ sender: UIButton) {
        self.toggle()
    }
    
    func toggle() {
        print("toggle")
        expanded = !expanded
        let height = expanded ? detailsElementHeight + defaultNavButtonPadding : (detailsElementHeight  + defaultNavButtonPadding) * (-1)
        NSLayoutConstraint.deactivate([self.expandedHeightConstraint!])
        self.expandedHeightConstraint = self.expandedView.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([self.expandedHeightConstraint!])
        self.expandedView.setNeedsLayout()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.delegate?.updateInternalHeight(height: height)
        
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

}
