//
//  BaseViewController.swift
//  PodcastArtist
//
//  Created by apple on 01.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift
import MBProgressHUD
import SwiftyJSON
import SVGKit
import CoreImage

enum NavButtonType {
    case left
    case right
}

enum MenuState {
    case hidden
    case shown
}

class TouchableScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
    }
}

class BaseViewController: UIViewController, CAAnimationDelegate {
    
    weak var barTop: UIView!
    weak var barTopButtonOne : UIButton!
    weak var barTopButtonTwo : UIButton!
    weak var barTopLabel : UILabel!

    weak var scrollView: TouchableScrollView!
    weak var contentView: UIView!
    
    //config file
    var config: NavConfig!

    //side menu
    weak var sideMenu: UIView!
    var state: MenuState = MenuState.hidden
    var menuAnimating: Bool = false
    var selectedItem: Int = -1
    
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
        self.view.backgroundColor = colorBackground
        
    }
    //public
    public func getSVGImage(name: String) ->UIImage {
        let namSvgImgVar: SVGKImage = SVGKImage(named: name)
        let namImjVar: UIImage = namSvgImgVar.uiImage
        return namImjVar
    }
    
    //public ui methods
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
    
    public func deactivateHeight() {
        guard self.contentView != nil else {
            return
        }
        NSLayoutConstraint.deactivate([self.contentHeightConstraint!])
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
    
    public func addNavButton(type: NavButtonType? = NavButtonType.left, image: String? = String(), title: String? = String(), size: CGSize? = defaultNavButtonSize) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title(title: title!)
        if title != "" {
            button.leftImage(image: UIImage(named: image!)!)
        } else {
            button.imageOnly(image: UIImage(named: image!)!)
        }
        if type == NavButtonType.left {
            button.addTarget(self, action: #selector(self.topBarOneTapped), for: .touchUpInside)
            self.barTop.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
                button.leadingAnchor.constraint(equalTo: self.barTop.leadingAnchor, constant: defaultNavButtonPadding),
                button.heightAnchor.constraint(equalToConstant: size!.height),
                button.widthAnchor.constraint(equalToConstant: size!.width),
            ])
            self.barTopButtonOne = button
        } else {
            button.addTarget(self, action: #selector(self.topBarTwoTapped(_:)), for: .touchUpInside)
            self.barTop.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
                button.trailingAnchor.constraint(equalTo: self.barTop.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
                button.heightAnchor.constraint(equalToConstant: size!.height),
                button.widthAnchor.constraint(equalToConstant: size!.width),
            ])
            self.barTopButtonTwo = button
        }
    }
    
    public func addNavigationButton(type: NavButtonType? = NavButtonType.left, image: UIImage? = UIImage(), title: String? = String(), size: CGSize? = defaultNavButtonSize) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title(title: title!)
        if title != "" {
            button.leftImage(image: image!)
        } else {
            button.imageOnly(image: image!)
        }
        if type == NavButtonType.left {
            button.addTarget(self, action: #selector(self.topBarOneTapped), for: .touchUpInside)
            self.barTop.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
                button.leadingAnchor.constraint(equalTo: self.barTop.leadingAnchor, constant: defaultNavButtonPadding),
                button.heightAnchor.constraint(equalToConstant: size!.height),
                button.widthAnchor.constraint(equalToConstant: size!.width),
            ])
            self.barTopButtonOne = button
        } else {
            button.addTarget(self, action: #selector(self.topBarTwoTapped(_:)), for: .touchUpInside)
            self.barTop.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: self.barTop.centerYAnchor),
                button.trailingAnchor.constraint(equalTo: self.barTop.trailingAnchor, constant: defaultNavButtonPadding * (-1)),
                button.heightAnchor.constraint(equalToConstant: size!.height),
                button.widthAnchor.constraint(equalToConstant: size!.width),
            ])
            self.barTopButtonTwo = button
        }
    }
    
    public func addNavTitle(title: String? = "") {
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
        barTopLabel.text = title
        barTopLabel.textColor = .white
        barTopLabel.textAlignment = .center
        self.barTopLabel = barTopLabel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        processTouch(touch: touch!)
    }
    
    public func processTouch(touch: UITouch) {
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

    //side menu
    @objc public func closeTapped(_ sender: UIButton) {
        self.closeButtonHandler()
    }
    
    func closeButtonHandler() {
        print("Close")
    }
    
    //private
    private func layoutViews() {
        initTopBar()
        initScroller()
    }
    
    private func initTopBar() {
        
        let barTop = UIView(frame: .zero)
        barTop.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(barTop)
        NSLayoutConstraint.activate([
            barTop.topAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.topAnchor),
            barTop.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            barTop.trailingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.trailingAnchor),
            barTop.heightAnchor.constraint(equalToConstant: config.top ? floatTopBarHeight : 0),
        ])
        barTop.backgroundColor = colorTopBar
        self.barTop = barTop
    }
    
    
    private func initScroller() {
        
        let scrollView = TouchableScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.barTop.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.trailingAnchor),
        ])
        self.scrollView = scrollView
        self.scrollView.isUserInteractionEnabled = true

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
    
    //image tint color
    private func changeTintColorWithImage(img: UIImage, tintColor: UIColor) ->UIImage {
        let imageIn = img;
        let rect: CGRect = CGRect(x: 0, y: 0, width: imageIn.size.width, height: imageIn.size.height);
        let alphaInfo: CGImageAlphaInfo = (imageIn.cgImage)!.alphaInfo
        let opaque: Bool = alphaInfo == CGImageAlphaInfo.noneSkipLast || alphaInfo == CGImageAlphaInfo.noneSkipLast || alphaInfo == CGImageAlphaInfo.none;
        UIGraphicsBeginImageContextWithOptions(imageIn.size, opaque, imageIn.scale);
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        context.translateBy(x: 0, y: imageIn.size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)
        context.clip(to: rect, mask: imageIn.cgImage!);
        context.setFillColor(tintColor.cgColor);
        context.fill(rect);
        let imageOut: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return imageOut;
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

//side menu
extension BaseViewController {
    
    @objc public func menuTapped(_ sender: UIButton) {
        print(sender.tag)
    }

    public func addSideMenu(items: Array<Any>) {
        self.initSideMenu(items: items)
    }
    
    public func toggleMenu() {
        if state == MenuState.hidden {
            openMenu()
        } else {
            closeMenu()
        }
    }
    
    public func openMenu() {
        self.sideMenu.isHidden = true
        self.sideMenu.transform = CGAffineTransform(translationX: -floatSideMenuWidth, y: 0)
        self.sideMenu.isHidden = false
        UIView.animate(withDuration: TimeInterval(menuAnimateDuration), delay: 0, options: .curveEaseInOut, animations: {
            self.sideMenu.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            self.state = MenuState.shown
        }
    }
    
    public func closeMenu() {
        if state == MenuState.shown {
            self.sideMenu.isHidden = false
            self.sideMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: TimeInterval(menuAnimateDuration), delay: 0.0, options: .curveEaseInOut, animations: {
                self.sideMenu.transform = CGAffineTransform(translationX: -floatSideMenuWidth, y: 0)
            }) { _ in
                self.state = MenuState.hidden
                self.onMenuClosed()
            }
        }
    }
    
    public func onMenuClosed() {
        
    }
    
    //private functions
    private func initSideMenu(items: Array<Any>) {
        
        if !config.side {
            return
        }
        
        let sideMenu = UIView(frame: .zero)
        sideMenu.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sideMenu)
        NSLayoutConstraint.activate([
            sideMenu.topAnchor.constraint(equalTo: self.barTop.topAnchor),
            sideMenu.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            sideMenu.widthAnchor.constraint(equalToConstant: floatSideMenuWidth),
            sideMenu.bottomAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.bottomAnchor),
        ])
        sideMenu.backgroundColor = colorMenu
        self.sideMenu = sideMenu

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: sidemenuLogoSize.width, height: sidemenuLogoSize.height))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "logo-side")
        imageView.image = image
        self.sideMenu.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.sideMenu.topAnchor, constant: defaultNavButtonPadding),
            imageView.centerXAnchor.constraint(equalTo: self.sideMenu.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: sidemenuLogoSize.height),
            imageView.widthAnchor.constraint(equalToConstant: sidemenuLogoSize.width),
        ])
        
        let closeButton = UIButton(type: .custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.frame = CGRect(x: 0, y: 0, width: iconButtonSize.width, height: iconButtonSize.height)
        let icon = getSVGImage(name: "cancel")
        let iconColored = changeTintColorWithImage(img: icon, tintColor: .white)
        let iconPressed = getSVGImage(name: "cancel-pressed")
        let iconPressedColored = changeTintColorWithImage(img: iconPressed, tintColor: .white)
        closeButton.setImage(iconColored, for: .normal)
        closeButton.setImage(iconPressedColored, for: .selected)
        closeButton.addTarget(self, action: #selector(self.closeTapped(_:)), for: .touchUpInside)
        self.sideMenu.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.sideMenu.topAnchor, constant: defaultNavButtonPadding),
            closeButton.trailingAnchor.constraint(equalTo: self.sideMenu.trailingAnchor, constant:  defaultNavButtonPadding * (-1)),
            closeButton.widthAnchor.constraint(equalToConstant: iconButtonSize.width),
            closeButton.heightAnchor.constraint(equalToConstant: iconButtonSize.height),
        ])

        let menuItems = NSMutableArray(array: items)
        
        var ypos = sidemenuLogoSize.height + defaultNavButtonPadding
        var tag = 0
        
        for item in menuItems {
            let arr = item as! NSArray
            let title = arr[0] as! String
            let image = arr[1] as! String
            let imagePressed = arr[2] as! String
            let icon = getSVGImage(name: image)
            let iconPressed = getSVGImage(name: imagePressed)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: menuButtonSize.width, height: menuButtonSize.height)
            button.title(title: title)
            button.leftImagePadding(image: icon, imagePressed: iconPressed, padding: defaultNavButtonPadding)
            button.tag = tag + 100
            if tag == selectedItem {
                button.applyGradient(with: [colorMenuSelected, colorMenuSelectedSemitransparent], gradient: GradientOrientation.horizontal)
            }
            button.translatesAutoresizingMaskIntoConstraints = false
                sideMenu.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: ypos),
                button.leadingAnchor.constraint(equalTo: self.sideMenu.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: self.sideMenu.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: menuButtonSize.height),
                button.widthAnchor.constraint(equalTo: self.sideMenu.widthAnchor),
            ])
            button.addTarget(self, action: #selector(self.menuTapped(_:)), for: .touchUpInside)
            ypos += menuButtonSize.height + defaultNavButtonPadding
            tag += 1
        }

        self.sideMenu = sideMenu
        self.sideMenu.dropShadow()

        self.sideMenu.transform = CGAffineTransform(translationX: -floatSideMenuWidth, y: 0)
        if state == MenuState.hidden {
            self.sideMenu.isHidden = true
        }
    }

}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical

    var startPoint : CGPoint {
        return points.startPoint
    }

    var endPoint : CGPoint {
        return points.endPoint
    }

    var points : GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
        case .horizontal:
            return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
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
    
    //shadow
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    //gradient vertical
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorGradientTop, colorGradientBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }

    func applyGradient(with colours: [UIColor], gradient orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func getImgFromVyuFnc() -> UIImage
    {
        UIGraphicsBeginImageContext(self.frame.size)

        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return image!
    }
    
    func getSVGImage(name: String) ->UIImage {
        let namSvgImgVar: SVGKImage = SVGKImage(named: name)
        let namImjVar: UIImage = namSvgImgVar.uiImage
        return namImjVar
    }
}

extension UIView {
 
 func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
         var topInset = CGFloat(0)
         var bottomInset = CGFloat(0)
         
         if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
     
        translatesAutoresizingMaskIntoConstraints = false
     
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}

// compatibleSafeAreaLayoutGuide
protocol LayoutGuideProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuideProvider { }
extension UILayoutGuide: LayoutGuideProvider { }

extension UIView {
    var compatibleSafeAreaLayoutGuide: LayoutGuideProvider {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide
        } else {
            return self
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func customPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])

    }
}

extension UIButton {
    func title(title: String? = "") {
        self.setTitle(title!, for: .normal)
    }
    
    func imageOnly(image: UIImage, renderMode: UIImage.RenderingMode? = .alwaysOriginal) {
        self.setImage(image.withRenderingMode(renderMode!), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode? = .alwaysOriginal) {
        self.setImage(image.withRenderingMode(renderMode!), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    func leftImagePadding(image: UIImage, imagePressed: UIImage? = nil, padding: CGFloat? = 0, renderMode: UIImage.RenderingMode? = .alwaysOriginal) {
        self.setImage(image.withRenderingMode(renderMode!), for: .normal)
        let pressed = imagePressed != nil ? imagePressed : image
        self.setImage(pressed!.withRenderingMode(renderMode!), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(padding!), bottom: 0, right: image.size.width / 2)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(padding!) + 10, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.semanticContentAttribute = .forceLeftToRight
        self.imageView?.contentMode = .scaleAspectFit
    }
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode? = .alwaysOriginal){
        self.setImage(image.withRenderingMode(renderMode!), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: image.size.width / 2, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 10)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
    func rightImagePadding(image: UIImage, padding: CGFloat? = 0, renderMode: UIImage.RenderingMode? = .alwaysOriginal){
        self.setImage(image.withRenderingMode(renderMode!), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: CGFloat(padding!))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: CGFloat(padding!) + 10)
        self.contentHorizontalAlignment = .right
        self.semanticContentAttribute = .forceRightToLeft
        self.imageView?.contentMode = .scaleAspectFit
    }
}

//border color
extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
}
