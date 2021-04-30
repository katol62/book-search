//
//  NextViewController.swift
//  EmptyNav
//
//  Created by apple on 05/10/2019.
//  Copyright © 2019 custom. All rights reserved.
//

import UIKit

enum State: Int {
    case one = 1, two, three
}

enum Direction {
    case left
    case right
    case none
}

class NextViewController: BaseViewController {

    weak var label: UILabel!
    weak var customView: UIView!
    weak var viewOne: UIView!
    weak var viewTwo: UIView!
    weak var viewThree: UIView!
    
    var finalHeight: CGFloat = 0

    let heightOne: CGFloat = 1000
    let heightTwo: CGFloat = 1300
    let heightThree: CGFloat = 400
    
    var currentState: State!
    var currentDirection: Direction!

    public override init(config: NavConfig? = NavConfig()) {
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        
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
        label.text = "Next View"
        label.textAlignment = .center
        label.backgroundColor = UIColor.yellow
        self.label = label

        
        finalHeight += self.label.intrinsicContentSize.height + 10
        
        let viewOne = UIView(frame: .zero)
        viewOne.translatesAutoresizingMaskIntoConstraints = false
        viewOne.backgroundColor = .cyan
        self.contentView.addSubview(viewOne)
        NSLayoutConstraint.activate([
            viewOne.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
            viewOne.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewOne.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewOne.heightAnchor.constraint(equalToConstant: heightOne)
        ])
        let labelOne = UILabel(frame: .zero)
        labelOne.translatesAutoresizingMaskIntoConstraints = false
        viewOne.addSubview(labelOne)
        NSLayoutConstraint.activate([
            labelOne.topAnchor.constraint(equalTo: viewOne.topAnchor, constant: 10),
            labelOne.centerXAnchor.constraint(equalTo: viewOne.centerXAnchor),
            labelOne.heightAnchor.constraint(equalToConstant: 32),
            labelOne.widthAnchor.constraint(equalToConstant: 120)
        ])
        labelOne.text = "View One"
        labelOne.textAlignment = .center

        self.viewOne = viewOne

        let viewTwo = UIView(frame: .zero)
        viewTwo.translatesAutoresizingMaskIntoConstraints = false
        viewTwo.backgroundColor = .brown
        self.contentView.addSubview(viewTwo)
        NSLayoutConstraint.activate([
            viewTwo.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
            viewTwo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewTwo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewTwo.heightAnchor.constraint(equalToConstant: heightTwo)
        ])
        let labelTwo = UILabel(frame: .zero)
        labelTwo.translatesAutoresizingMaskIntoConstraints = false
        viewTwo.addSubview(labelTwo)
        NSLayoutConstraint.activate([
            labelTwo.topAnchor.constraint(equalTo: viewTwo.topAnchor, constant: 10),
            labelTwo.centerXAnchor.constraint(equalTo: viewTwo.centerXAnchor),
            labelTwo.heightAnchor.constraint(equalToConstant: 32),
            labelTwo.widthAnchor.constraint(equalToConstant: 120)
        ])
        labelTwo.text = "View Two"
        labelTwo.textAlignment = .center
        self.viewTwo = viewTwo

        let viewThree = UIView(frame: .zero)
        viewThree.translatesAutoresizingMaskIntoConstraints = false
        viewThree.backgroundColor = .yellow
        self.contentView.addSubview(viewThree)
        NSLayoutConstraint.activate([
            viewThree.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
            viewThree.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewThree.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewThree.heightAnchor.constraint(equalToConstant: heightThree)
        ])
        let labelThree = UILabel(frame: .zero)
        labelThree.translatesAutoresizingMaskIntoConstraints = false
        viewThree.addSubview(labelThree)
        NSLayoutConstraint.activate([
            labelThree.topAnchor.constraint(equalTo: viewThree.topAnchor, constant: 10),
            labelThree.centerXAnchor.constraint(equalTo: viewThree.centerXAnchor),
            labelThree.heightAnchor.constraint(equalToConstant: 32),
            labelThree.widthAnchor.constraint(equalToConstant: 120)
        ])
        labelThree.text = "View Three"
        labelThree.textAlignment = .center
        self.viewThree = viewThree
        self.show(view: self.viewThree, display: false)

//        finalHeight += 1000
//
        //final content height
        //let finalHeight = imageview.intrinsicContentSize.height
//        self.updateHeight(height: finalHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonTitle(button: barBottomButtonOne, title: "Cancel")
        buttonTitle(button: barBottomButtonTwo, title: "Continue")

        updateUi()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view intrinsic content size: \(view.intrinsicContentSize)")
        print("contentView intrinsic content size: \(contentView.intrinsicContentSize)")
        print("scrollView intrinsic content size: \(scrollView.intrinsicContentSize)")
        
        currentState = State.one
        currentDirection = Direction.none
        updateUi()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //click handlers
    
    override public func leftButtonHandler() {
        if currentState == State.one {
            self.pop(animated: true)
        } else {
            currentState = State(rawValue: currentState!.rawValue - 1)
            currentDirection = Direction.right
            updateUi()
        }
    }

    override public func rightButtonHandler() {
        if currentState == State.three {
            let bartop = Bar(one: true, second: false)
            let config = NavConfig(top: bartop)
            let nc = SecondViewController(config: config)
            self.open(ofKind: SecondViewController.self, pushController: nc)
        } else {
            currentState = State(rawValue: currentState!.rawValue + 1)
            currentDirection = Direction.left
            updateUi()
        }
    }

    override public func topButtonHandler() {
        self.pop(animated: true)
    }

    override public func bottomButtonHandler() {
        let bartop = Bar(one: true, second: false)
        let config = NavConfig(top: bartop)
        let nc = SecondViewController(config: config)
        self.open(ofKind: SecondViewController.self, pushController: nc)
    }
    
    // ui functions

    private func show(view: UIView, display: Bool) {
        view.isHidden = !display
    }
    
    private func updateUi() {
        if currentState == State.one {
            show(view: viewOne, display: true)
            show(view: viewTwo, display: false)
            show(view: viewThree, display: false)
            view.bringSubviewToFront(viewOne)
            if currentDirection == Direction.left {
                viewOne.slideInFromRight(duration: 0.5, completionDelegate: self)
            } else if currentDirection == Direction.right {
                viewOne.slideInFromLeft(duration: 0.5, completionDelegate: self)
            } else {
                finalHeight = self.label.intrinsicContentSize.height + 10 + heightOne
                updateHeight(height: finalHeight)
            }
        }
        else if currentState == State.two {
            show(view: viewOne, display: false)
            show(view: viewTwo, display: true)
            show(view: viewThree, display: false)
            view.bringSubviewToFront(viewTwo)
            if currentDirection == Direction.left {
                viewTwo.slideInFromRight(duration: 0.5, completionDelegate: self)
            } else if currentDirection == Direction.right {
                viewTwo.slideInFromLeft(duration: 0.5, completionDelegate: self)
            } else {
                finalHeight = self.label.intrinsicContentSize.height + 10 + heightTwo
                updateHeight(height: finalHeight)
            }
        }
        else if currentState == State.three {
            show(view: viewOne, display: false)
            show(view: viewTwo, display: false)
            show(view: viewThree, display: true)
            view.bringSubviewToFront(viewThree)
            if currentDirection == Direction.left {
                viewThree.slideInFromRight(duration: 0.5, completionDelegate: self)
            } else if currentDirection == Direction.right {
                viewThree.slideInFromLeft(duration: 0.5, completionDelegate: self)
            } else {
                finalHeight = self.label.intrinsicContentSize.height + 10 + heightThree
                updateHeight(height: finalHeight)
            }
        }
    }
    
    override func animationStoppped() {
        print("Animation stopped")
        if currentState == State.one {
            finalHeight = self.label.intrinsicContentSize.height + 10 + heightOne
            updateHeight(height: finalHeight)
        }
        else if currentState == State.two {
            finalHeight = self.label.intrinsicContentSize.height + 10 + heightTwo
            updateHeight(height: finalHeight)
        }
        else if currentState == State.three {
            finalHeight = self.label.intrinsicContentSize.height + 10 + heightThree
            updateHeight(height: finalHeight)
        }
    }

    
}
