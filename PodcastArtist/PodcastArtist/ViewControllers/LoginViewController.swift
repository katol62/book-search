//
//  LoginViewController.swift
//  PodcastArtist
//
//  Created by apple on 02.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import Toast_Swift
import MBProgressHUD
import SwiftyJSON

class LoginViewController: BaseViewController, UITextFieldDelegate {

    weak var containerView: UIView!
    weak var logo: UIImageView!
    weak var formView: UIView!
    
    weak var formTitleLabel: UILabel!
    weak var formEmailTextField: UITextField!
    weak var formPasswordTextField: UITextField!
    weak var formLoginButton: UIButton!

    fileprivate var containerHeightConstraint: NSLayoutConstraint?

    public override init(config: NavConfig? = NavConfig()) {
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
                
        initContainer()
        initLogo()
        initForm()
        
        //calculate height
        let finalHeight = self.logo.intrinsicContentSize.height + 50 + loginFormSize.height + 30
        
        NSLayoutConstraint.deactivate([self.containerHeightConstraint!])
        self.containerHeightConstraint = self.containerView.heightAnchor.constraint(equalToConstant: finalHeight)
        NSLayoutConstraint.activate([self.containerHeightConstraint!])
        self.containerView.setNeedsLayout()

        //final content height
        self.updateHeight(height: finalHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.isUserInteractionEnabled = false

        self.formView.setGradientBackground()
        self.formView.dropShadow()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Helper.hasValue(forKey: s_PROFILE) {
            let initPecodedProfile = Helper.getObjectFromDefaults(returningClass: ProfileObject.self, forKey: s_PROFILE) as! ProfileObject
            let email = initPecodedProfile.Email
            let password = initPecodedProfile.Password
            formEmailTextField.text = email
            formPasswordTextField.text = password
        }
    }

    
    //private UI methods
    private func initContainer() {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerView)
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.containerHeightConstraint!
        ])
        self.containerView = containerView
    }
    
    private func initLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: loginLogoSize.width, height: loginLogoSize.height))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "logo-login")
        imageView.image = image
        self.containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: loginLogoSize.height),
            imageView.widthAnchor.constraint(equalToConstant: loginLogoSize.width),
        ])
        self.logo = imageView

    }
    
    private func initForm() {
        let formView = UIView(frame: .zero)
        formView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(formView)
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: self.logo.bottomAnchor, constant: 30),
            formView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            formView.heightAnchor.constraint(equalToConstant: loginFormSize.height),
            formView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: loginFormPadding),
            formView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: loginFormPadding * (-1)),

        ])
        formView.layer.masksToBounds = false
        formView.layer.cornerRadius = 10
        formView.layer.borderWidth = 1.0
        formView.layer.borderColor = UIColor.black.cgColor
        self.formView = formView
        
        //form elements
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.formView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.formView.topAnchor, constant: 30),
            label.heightAnchor.constraint(equalToConstant: 34),
            label.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: -20),
        ])
        label.text = "Artist account"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        self.formTitleLabel = label

        let emailTf = UITextField(frame: .zero)
        emailTf.translatesAutoresizingMaskIntoConstraints = false
        self.formView.addSubview(emailTf)
        NSLayoutConstraint.activate([
            emailTf.topAnchor.constraint(equalTo: self.formTitleLabel.bottomAnchor, constant: 20),
            emailTf.heightAnchor.constraint(equalToConstant: 44),
            emailTf.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: 20),
            emailTf.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: -20),
        ])
        emailTf.customPlaceholder(text: "Email address", color: formPlaceholderColor)
        emailTf.font = UIFont.systemFont(ofSize: 18)
        emailTf.textColor = .white
        emailTf.layer.cornerRadius = 5
        emailTf.backgroundColor = formTextfieldBackground
        emailTf.setLeftPaddingPoints(10)
        emailTf.setRightPaddingPoints(10)
        emailTf.delegate = self
        self.formEmailTextField = emailTf

        let passwordTf = UITextField(frame: .zero)
        passwordTf.translatesAutoresizingMaskIntoConstraints = false
        self.formView.addSubview(passwordTf)
        NSLayoutConstraint.activate([
            passwordTf.topAnchor.constraint(equalTo: self.formEmailTextField.bottomAnchor, constant: 10),
            passwordTf.heightAnchor.constraint(equalToConstant: 44),
            passwordTf.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: 20),
            passwordTf.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: -20),
        ])
        passwordTf.customPlaceholder(text: "Password", color: formPlaceholderColor)
        passwordTf.font = UIFont.systemFont(ofSize: 18)
        passwordTf.textColor = .white
        passwordTf.layer.cornerRadius = 5
        passwordTf.isSecureTextEntry = true
        passwordTf.backgroundColor = formTextfieldBackground
        passwordTf.setLeftPaddingPoints(10)
        passwordTf.setRightPaddingPoints(10)
        passwordTf.delegate = self
        self.formPasswordTextField = passwordTf

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title(title: "Login")
        button.addTarget(self, action: #selector(self.onLoginClicked), for: .touchUpInside)
        self.formView.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: self.formView.bottomAnchor, constant: -30),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: -20),
        ])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = formButtonBackground
        self.formLoginButton = button
    }
    
    //click handlers
    @objc public func onLoginClicked(_ sender: UIButton) {
        self.loginHandler()
    }
    
    func loginHandler() {
        print("login clicked")
        self.view.endEditing(true)
        processlogin()
    }
    
    //text field delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("change")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    // close keyboard on touch
    override public func processTouch(touch: UITouch) {
        if touch.view != formEmailTextField && touch.view != formPasswordTextField {
            self.view.endEditing(true)
        }
    }
    
    // process login
    
    private func isCorrect() -> Bool {
        if formEmailTextField.text!.isEmpty || !Helper.isValidEmail(testStr: formEmailTextField.text!) || formPasswordTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    private func processlogin() {
        
        if !isCorrect() {
            self.view.makeToast("Fill form fields")
            return
        }
        
        let email = formEmailTextField.text!
        let password = formPasswordTextField.text!
        
        self.doLogin(email, password)

        
    }
    
    //rest api requests

    private func doLogin(_ email:String, _ password:String) {
        
        let params : [String : String] = [k_EMAIL     : email,
                                       k_PASSWORD     : password,
                                       k_DEVICE_TOKEN : "123456789",
                                       k_DEVICE_TYPE  : "ios"]
        
        print(params)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        RestClient.post(serviceName: LOGIN, parameters: params) { (json:JSON?, error:NSError?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                print(error?.localizedDescription ?? String())
                return
            } else {
                print(json!)
                if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_TRUE) {
                    
                    if json?["data"][k_USER_TYPE].stringValue != USER_TYPE_IS_DJ && json?["data"][k_USER_TYPE].stringValue != USER_TYPE_IS_TECH {
                        // not artist
                        self.view.makeToast("User is not an artist")
                        return
                    }

                    if Helper.hasValue(forKey: s_PROFILE) {
                        let initPecodedProfile = Helper.getObjectFromDefaults(returningClass: ProfileObject.self, forKey: s_PROFILE) as! ProfileObject
                        
                        print (initPecodedProfile)
                    }

                    let rootJSON = json?[k_SERVICE_DATA]
                    let profile = ProfileObject.build(json: (rootJSON)!)
                    
                    //saving profile & user id
                    Helper.storeObjectInDefaults(profile, forKey: s_PROFILE)
                    Helper.setValueInUserDefaults(value: (json?["data"][k_USER_ID].stringValue)!, forKey: k_USER_ID)
                    
                    let decodedProfile = Helper.getObjectFromDefaults(returningClass: ProfileObject.self, forKey: s_PROFILE) as! ProfileObject
                    
                    print (decodedProfile)

                    if json?["data"][k_USER_TYPE].stringValue == USER_TYPE_IS_TECH {
                        Helper.setValueInUserDefaults(value: (json?["data"][k_PARENT_ID].stringValue)!, forKey: k_USER_ID)
                    }
                    
                    let config = NavConfig(top: true, side: true)
                    let nc = DashboardViewController(config: config)
                    nc.selectedItem = 0
                    self.open(ofKind: DashboardViewController.self, pushController: nc)
                        
                } else if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_FALSE) {
                    Helper.removeReference()
                    self.view.makeToast((json?[k_SERVICE_MESSAGE].stringValue)!)
                }
            }
        }
    }
            

}
