//
//  BaseViewController.swift
//  ArtistPodcast
//
//  Created by apple on 19.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import Toast_Swift
import MBProgressHUD
import SwiftyJSON
import SVGKit
import CoreImage

class BaseViewController: UIViewController {
    
    lazy var topBar: TopBar = {
        let topBar = TopBar(frame: .zero)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        return topBar
    }()

    lazy var sideMenu: SideMenu = {
        let menu = SideMenu(frame: .zero)
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()

    lazy var scrollView: UIScrollView = {
        let scroller = UIScrollView()
        scroller.translatesAutoresizingMaskIntoConstraints = false
        return scroller
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Theme.colorBackground
    }
    
}

/* EXTENSIONS */

//navigation
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
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}

//MISC UI
extension UIView {
    //border color
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
    //
    func getSVGImage(name: String) ->UIImage {
        guard let namSvgImgVar: SVGKImage = SVGKImage(named: name) else {
            return UIImage()
        }
        let namImjVar: UIImage = namSvgImgVar.uiImage
        return namImjVar
    }
    func changeTintColorWithImage(img: UIImage, tintColor: UIColor) ->UIImage {
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
    
    func applyGradient(with colours: [UIColor], gradient orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 1, offSet: CGSize = CGSize(width: 0, height: 3), radius: CGFloat = 10, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1

    }
}

//BUTTON
extension UIButton {
    func title(title: String? = "") {
        self.setTitle(title!, for: .normal)
    }

    func titleSelected(title: String? = "") {
        self.setTitle(title!, for: .selected)
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
        self.setImage(pressed!.withRenderingMode(renderMode!), for: .selected)
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
    func rightImagePadding(image: UIImage, imagePressed: UIImage? = nil, padding: CGFloat? = 0, renderMode: UIImage.RenderingMode? = .alwaysOriginal){
        self.setImage(image.withRenderingMode(renderMode!), for: .normal)
        let pressed = imagePressed != nil ? imagePressed : image
        self.setImage(pressed!.withRenderingMode(renderMode!), for: .selected)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: CGFloat(padding!))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: CGFloat(padding!) + 10)
        self.contentHorizontalAlignment = .right
        self.semanticContentAttribute = .forceRightToLeft
        self.imageView?.contentMode = .scaleAspectFit
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

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [UIColor], orientation: GradientOrientation? = .vertical ) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = orientation!.startPoint
        gradientLayer.endPoint = orientation!.endPoint
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
    }
}

extension UIView {
    func parentController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentController()
        } else {
            return nil
        }
    }
}
