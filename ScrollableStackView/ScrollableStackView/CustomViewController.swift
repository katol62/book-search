//
//  ViewController.swift
//  ScrollableStackView
//
//  Created by apple on 18.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    let height : CGFloat = 100
    let heightExpanded : CGFloat = 150

    
    override func loadView() {
        super.loadView()
        layoutViews()
    }

    func layoutViews() {
        // Scroll view, vertical
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
          scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
          scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        // 1. The content is just a green view
        /*
          let greenView = UIView()
          greenView.backgroundColor = .green
          scrollView.addSubview(greenView)
          greenView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
            // Attaching the content's edges to the scroll view's edges
            greenView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            greenView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            greenView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            greenView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Satisfying size constraints
            greenView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            greenView.heightAnchor.constraint(equalToConstant: 2000),
          ])
        */

        // 2. Content is a stack view
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fill
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          // Attaching the content's edges to the scroll view's edges
          stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
          stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
          stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

          // Satisfying size constraints
          stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Add arranged subviews:
        for i in 0...20 {
          // A simple green view.
            let greenView = UIView()
            greenView.backgroundColor = .green
            stackView.addArrangedSubview(greenView)
            greenView.translatesAutoresizingMaskIntoConstraints = false
            // Doesn't have intrinsic content size, so we have to provide the height at least
            greenView.heightAnchor.constraint(equalToConstant: height).isActive = true
            
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            greenView.addSubview(button)
            button.setTitle("Click", for: .normal)
            button.backgroundColor = .red
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 300).isActive = true
            button.centerXAnchor.constraint(equalTo: greenView.centerXAnchor).isActive = true
            button.addTarget(self, action: #selector(self.topBarOneTapped), for: .touchUpInside)
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc public func topBarOneTapped(_ sender: UIButton) {
        print(sender.superview?.frame.size.height ?? "No data")
        
        let view: UIView = sender.superview!

        let hght: CGFloat = view.frame.size.height
        let newheight = hght == height ? heightExpanded : height
        var fr = view.frame
        fr.size.height = newheight
        view.frame = fr
        view.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: newheight)
        view.layoutIfNeeded()
        
        stackView.setNeedsUpdateConstraints()
        stackView.layoutIfNeeded()
        scrollView.layoutIfNeeded()

//        self.leftButtonHandler()
    }
    
    func leftButtonHandler() {
        print("Top Bar One")
    }

}

extension UIView {
    
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
