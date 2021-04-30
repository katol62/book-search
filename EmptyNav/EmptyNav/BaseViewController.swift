//
//  BaseViewController.swift
//  EmptyNav
//
//  Created by apple on 09.10.2019.
//  Copyright © 2019 custom. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, CAAnimationDelegate {
    
    weak var barTop: UIView!
    weak var barTopButtonOne : UIButton!
    weak var barTopButtonTwo : UIButton!
    weak var barTopLabel : UILabel!

    weak var barBottom: UIView!
    weak var barBottomButtonOne : UIButton!
    weak var barBottomButtonTwo : UIButton!

    weak var scrollView: UIScrollView!
    weak var contentView: UIView!

    var config: NavConfig!
    
    fileprivate var contentHeightConstraint: NSLayoutConstraint?

    public init(config: NavConfig? = NavConfig()) {
        super.init(nibName: nil, bundle: nil)
        self.config = config
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        layoutViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
    }
    
    //public ui methods
    public func buttonTitle(button: UIButton?, title: String? = "") {
        guard button != nil else {
            return
        }
        button!.setTitle(title, for: .normal)
        button!.setTitle(title, for: .selected)
        button!.setTitle(title, for: .disabled)
    }
    
    public func headerTitle(title: String? = "") {
        guard self.barTopLabel != nil else {
            return
        }
        self.barTopLabel.text = title
    }
    
    public func setVisible(button: UIButton?, visible: Bool) {
        guard button != nil else {
            return
        }
        button!.isHidden = !visible
    }
    
    public func updateHeight(height: CGFloat) {
        guard self.contentView != nil else {
            return
        }
        NSLayoutConstraint.deactivate([self.contentHeightConstraint!])
        self.contentHeightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([self.contentHeightConstraint!])
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
    }
    
    //click handlers
    @objc public func topBarOneTapped(_ sender: UIButton) {
        self.leftButtonHandler()
    }
    
    func leftButtonHandler() {
        print("Top Bar One")
    }

    @objc public func topBarTwoTapped(_ sender: UIButton) {
        self.rightButtonHandler()
    }
    
    func rightButtonHandler() {
        print("Top Bar Two")
    }

    @objc public func bottomBarOneTapped(_ sender: UIButton) {
        self.topButtonHandler()
    }
    
    func topButtonHandler() {
        print("Bottom Bar One")
    }

    @objc public func bottomBarTwoTapped(_ sender: UIButton) {
        self.bottomButtonHandler()
    }
    
    func bottomButtonHandler() {
        print("Bottom Bar Two")
    }

    //private
    private func layoutViews() {
        initTopBar()
        initBottomBar()
        initScroller()
    }
    
    private func initTopBar() {
        
        let barTop = UIView(frame: .zero)
        barTop.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(barTop)
        NSLayoutConstraint.activate([
            barTop.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            barTop.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            barTop.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            barTop.heightAnchor.constraint(equalToConstant: config.barTop.display ? floatTopBarHeight : 0),
        ])
        barTop.backgroundColor = colorTopBar
        self.barTop = barTop
        
        //top bar button one
        let barTopButtonOne = UIButton(type: .custom)
        barTopButtonOne.frame = CGRect(x: 0, y: 0, width: topBarButtonOne.width, height: topBarButtonOne.height)
        barTopButtonOne.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle(button: barTopButtonOne, title: "Back")
        barTopButtonOne.addTarget(self, action: #selector(self.topBarOneTapped), for: .touchUpInside)
        self.barTop.addSubview(barTopButtonOne)
        NSLayoutConstraint.activate([
            barTopButtonOne.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
            barTopButtonOne.leadingAnchor.constraint(equalTo: self.barTop.leadingAnchor, constant: 10),
            barTopButtonOne.heightAnchor.constraint(equalToConstant: topBarButtonOne.height),
            barTopButtonOne.widthAnchor.constraint(equalToConstant: topBarButtonOne.width),
        ])
        self.barTopButtonOne = barTopButtonOne
        setVisible(button: self.barTopButtonOne, visible: config.barTop.one)

        //top bar button two
        let barTopButtonTwo = UIButton(type: .custom)
        barTopButtonTwo.frame = CGRect(x: 0, y: 0, width: topBarButtonTwo.width, height: topBarButtonOne.height)
        barTopButtonTwo.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle(button: barTopButtonTwo, title: "Next")
        barTopButtonTwo.addTarget(self, action: #selector(self.topBarTwoTapped(_:)), for: .touchUpInside)
        self.barTop.addSubview(barTopButtonTwo)
        NSLayoutConstraint.activate([
            barTopButtonTwo.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
            barTopButtonTwo.trailingAnchor.constraint(equalTo: self.barTop.trailingAnchor, constant: -10),
            barTopButtonTwo.heightAnchor.constraint(equalToConstant: topBarButtonTwo.height),
            barTopButtonTwo.widthAnchor.constraint(equalToConstant: topBarButtonTwo.width),
        ])
        self.barTopButtonTwo = barTopButtonTwo
        setVisible(button: self.barTopButtonTwo, visible: config.barTop.two)

        //top bar title
        let barTopLabel = UILabel(frame: .zero)
        barTopLabel.translatesAutoresizingMaskIntoConstraints = false
        self.barTop.addSubview(barTopLabel)
        NSLayoutConstraint.activate([
            barTopLabel.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
            barTopLabel.centerXAnchor.constraint(equalTo: self.barTop.centerXAnchor),
            barTopLabel.leadingAnchor.constraint(equalTo: self.barTopButtonOne.trailingAnchor),
            barTopLabel.trailingAnchor.constraint(equalTo: self.barTopButtonTwo.leadingAnchor),
            barTopLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        barTopLabel.text = ""
        barTopLabel.textAlignment = .center
        self.barTopLabel = barTopLabel

    }
    
    private func initBottomBar() {
        
        let barBottom = UIView(frame: .zero)
        barBottom.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(barBottom)
        NSLayoutConstraint.activate([
            barBottom.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            barBottom.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            barBottom.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            barBottom.heightAnchor.constraint(equalToConstant: config.barBottom.display ? floatBottomBarHeight : 0),
        ])
        barBottom.backgroundColor = colorBottomBar
        self.barBottom = barBottom
        
        //bottom bar button one
        let barBottomButtonOne = UIButton(type: .custom)
        barBottomButtonOne.frame = CGRect(x: 0, y: 0, width: bottomBarButtonOne.width, height: bottomBarButtonOne.height)
        barBottomButtonOne.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle(button: barBottomButtonOne, title: "Continue")
        barBottomButtonOne.addTarget(self, action: #selector(self.bottomBarOneTapped), for: .touchUpInside)
        self.barBottom.addSubview(barBottomButtonOne)
        NSLayoutConstraint.activate([
            barBottomButtonOne.centerXAnchor.constraint(equalTo: self.barBottom.centerXAnchor),
            barBottomButtonOne.topAnchor.constraint(equalTo: self.barBottom.topAnchor, constant: 10),
            barBottomButtonOne.heightAnchor.constraint(equalToConstant: bottomBarButtonOne.height),
            barBottomButtonOne.widthAnchor.constraint(equalToConstant: bottomBarButtonOne.width),
        ])
        self.barBottomButtonOne = barBottomButtonOne
        setVisible(button: self.barBottomButtonOne, visible: config.barBottom.one)

        //bottom bar button one
        let barBottomButtonTwo = UIButton(type: .custom)
        barBottomButtonTwo.frame = CGRect(x: 0, y: 0, width: bottomBarButtonOne.width, height: bottomBarButtonOne.height)
        barBottomButtonTwo.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle(button: barBottomButtonTwo, title: "Continue")
        barBottomButtonTwo.addTarget(self, action: #selector(self.bottomBarTwoTapped), for: .touchUpInside)
        self.barBottom.addSubview(barBottomButtonTwo)
        NSLayoutConstraint.activate([
            barBottomButtonTwo.centerXAnchor.constraint(equalTo: self.barBottom.centerXAnchor),
            barBottomButtonTwo.topAnchor.constraint(equalTo: self.barBottomButtonOne.bottomAnchor, constant: 10),
            barBottomButtonTwo.heightAnchor.constraint(equalToConstant: bottomBarButtonTwo.height),
            barBottomButtonTwo.widthAnchor.constraint(equalToConstant: bottomBarButtonTwo.width),
        ])
        self.barBottomButtonTwo = barBottomButtonTwo
        setVisible(button: self.barBottomButtonTwo, visible: config.barBottom.two)

    }
    
    private func initScroller() {
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.barTop.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.barBottom.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        self.scrollView = scrollView

        let contentView = UIView(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(contentView)
        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.contentHeightConstraint!
        ])
        self.contentView = contentView

    }
    
    //sliding
    @objc func animationStoppped() {
        print("Animation stopped")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationStoppped()
    }
    
}

extension UIViewController {
    
    var navigator: UINavigationController {
        get {
            let rootViewController =  UIApplication.shared.keyWindow?.rootViewController
            let nc = (rootViewController as! UINavigationController)
            return nc
        }
        set {
        }
    }
    
    func pop(animated: Bool) {
        self.navigator.popViewController(animated: animated)
    }
    
    func openold(controller: UIViewController?, animated: Bool) {
        
        if self.navigator.viewControllers.contains(where: { $0 == controller }) {
            self.navigator.popToViewController(controller!, animated: animated)
        } else {
            self.navigator.pushViewController(controller!, animated: animated)
        }
    }
    

    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.navigator.viewControllers.contains(where: { $0.isKind(of: kind) })
    }

    func open(ofKind kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: kind) {
            for controller in self.navigator.viewControllers {
                if controller.isKind(of: kind) {
                    self.navigator.popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            self.navigator.pushViewController(pushController, animated: true)
        }
    }
    
}

extension UIView {
    func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let slideInFromLeftTransition = CATransition()

        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
        }

        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed

        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let slideInFromRightTransition = CATransition()

        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate as? CAAnimationDelegate
        }

        slideInFromRightTransition.type = CATransitionType.push
        slideInFromRightTransition.subtype = CATransitionSubtype.fromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromRightTransition.fillMode = CAMediaTimingFillMode.removed

        self.layer.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
    
}
