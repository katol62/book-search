//
//  MainViewController.swift
//  EmptyNav
//
//  Created by apple on 09.10.2019.
//  Copyright © 2019 custom. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    weak var label: UILabel!
    weak var imageView: UIImageView!
    
    public override init(config: NavConfig? = NavConfig()) {
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Image")
        imageView.image = image
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])
        self.imageView = imageView

        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 32),
            label.widthAnchor.constraint(equalToConstant: 120)
        ])
        label.text = "Main view"
        label.textAlignment = .center
        label.backgroundColor = UIColor.yellow
        self.label = label

        //final content height
        let finalHeight = imageView.intrinsicContentSize.height
        self.updateHeight(height: finalHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view intrinsic content size: \(view.intrinsicContentSize)")
        print("imageView intrinsic content size: \(imageView.intrinsicContentSize)")
        print("contentView intrinsic content size: \(contentView.intrinsicContentSize)")
        print("scrollView intrinsic content size: \(scrollView.intrinsicContentSize)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func rightButtonHandler() {
        super.rightButtonHandler()
        
        let bartop = Bar(one: true, second: true)
        let config = NavConfig(top: bartop)
        let nc = NextViewController(config: config)
        self.open(ofKind: NextViewController.self, pushController: nc)
    }


}
