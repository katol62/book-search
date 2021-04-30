//
//  SecondViewController.swift
//  EmptyNav
//
//  Created by apple on 05/10/2019.
//  Copyright © 2019 custom. All rights reserved.
//

import UIKit

class SecondViewController: BaseViewController {

    weak var label: UILabel!
    weak var customView: UIView!
    
    public override init(config: NavConfig? = NavConfig()) {
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()

        var finalHeight: CGFloat = 0
        
        //custom content
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 32),
            label.widthAnchor.constraint(equalToConstant: 120)
        ])
        label.text = "Second View"
        label.textAlignment = .center
        label.backgroundColor = UIColor.yellow
        self.label = label

        
        finalHeight += self.label.intrinsicContentSize.height + 10
        
        let customView = UIView(frame: .zero)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .orange
        self.contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
            customView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            customView.heightAnchor.constraint(equalToConstant: 1000)
        ])
        self.customView = customView

        finalHeight += 1000

        //final content height
        //let finalHeight = imageview.intrinsicContentSize.height
        self.updateHeight(height: finalHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonTitle(button: barBottomButtonOne, title: "Main View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view intrinsic content size: \(view.intrinsicContentSize)")
        print("contentView intrinsic content size: \(contentView.intrinsicContentSize)")
        print("scrollView intrinsic content size: \(scrollView.intrinsicContentSize)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //click handlers
    
    override public func leftButtonHandler() {
        self.pop(animated: true)
    }

    override public func topButtonHandler() {
        let bartop = Bar(one: false, second: true)
        let barbottom = Bar(display: false)
        let config = NavConfig(top: bartop, bottom: barbottom)
        let nc = MainViewController(config: config)
        self.open(ofKind: MainViewController.self, pushController: nc)
    }

}
