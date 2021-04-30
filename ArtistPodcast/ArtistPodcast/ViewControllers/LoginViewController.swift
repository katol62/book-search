//
//  LoginViewController.swift
//  ArtistPodcast
//
//  Created by apple on 20.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import QuartzCore

class LoginViewController: BaseViewController {

    lazy var logo: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "logo-login")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var formView: UIView = {
        let formView = UIView(frame: .zero)
        formView.translatesAutoresizingMaskIntoConstraints = false
//        formView.layer.masksToBounds = false
        formView.layer.cornerRadius = 10
        formView.layer.borderWidth = 2.0
        formView.clipsToBounds = true
        formView.backgroundColor = Theme.colorGradientTop
        formView.layer.borderColor = Theme.colorGradientBottom.cgColor
        return formView
    }()
    
    lazy var formTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = loginScreenTitles["TitleLabel"]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Theme.colorTextBase
        return label
    }()
    
    lazy var formEmailTextField: UITextField = {
        let emailTf = UITextField(frame: .zero)
        emailTf.translatesAutoresizingMaskIntoConstraints = false
        self.formView.addSubview(emailTf)
        emailTf.customPlaceholder(text: loginScreenTitles["EmailLabel"]!, color: Theme.formPlaceholderColor)
        emailTf.font = UIFont.systemFont(ofSize: 18)
        emailTf.textColor = Theme.colorTextBase
        emailTf.layer.cornerRadius = 5
        emailTf.backgroundColor = Theme.formTextfieldBackground
        emailTf.setLeftPaddingPoints(10)
        emailTf.setRightPaddingPoints(10)
        emailTf.layer.borderWidth = 1
        emailTf.layer.borderColor = Theme.colorGradientBottom.cgColor
        emailTf.delegate = self
        return emailTf
    }()
    
    lazy var formPasswordTextField: UITextField = {
        let passwordTf = UITextField(frame: .zero)
        passwordTf.translatesAutoresizingMaskIntoConstraints = false
        passwordTf.customPlaceholder(text: loginScreenTitles["PasswordLabel"]!, color: Theme.formPlaceholderColor)
        passwordTf.font = UIFont.systemFont(ofSize: 18)
        passwordTf.textColor = Theme.colorTextBase
        passwordTf.layer.cornerRadius = 5
        passwordTf.isSecureTextEntry = true
        passwordTf.backgroundColor = Theme.formTextfieldBackground
        passwordTf.setLeftPaddingPoints(10)
        passwordTf.setRightPaddingPoints(10)
        passwordTf.layer.borderWidth = 1
        passwordTf.layer.borderColor = Theme.colorGradientBottom.cgColor
        passwordTf.delegate = self
        return passwordTf
    }()
    
    lazy var formloginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title(title: "Login")
        button.addTarget(self, action: #selector(self.onLoginClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(Theme.colorTextBase, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = Theme.formButtonBackground
        return button
    }()
    
    override public init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        loadSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        formView.applyGradient(with: [Theme.colorGradientTop, Theme.colorGradientBottom], gradient: .vertical)
        formView.dropShadow(color: .black)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view != formEmailTextField && touch.view != formPasswordTextField {
            self.view.endEditing(true)
        }
    }

    private func loadSubviews() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 50
        stackView.distribution = .fill
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
          stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
          stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
          stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        //add logo
        stackView.addArrangedSubview(logo)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 10),
            logo.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: loginLogoSize.height),
            logo.widthAnchor.constraint(equalToConstant: loginLogoSize.width),
        ])

        stackView.addArrangedSubview(formView)
        NSLayoutConstraint.activate([
            formView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            formView.heightAnchor.constraint(equalToConstant: loginFormSize.height),
            formView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: loginFormPadding),
            formView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: loginFormPadding * (-1)),
        ])
        
        formView.addSubview(formTitleLabel)
        NSLayoutConstraint.activate([
            formTitleLabel.topAnchor.constraint(equalTo: self.formView.topAnchor, constant: floatFormPadding),
            formTitleLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
            formTitleLabel.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: floatFormPadding),
            formTitleLabel.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: floatFormPadding * (-1)),
        ])
        
        formView.addSubview(formEmailTextField)
        NSLayoutConstraint.activate([
            formEmailTextField.topAnchor.constraint(equalTo: self.formTitleLabel.bottomAnchor, constant: floatFormPadding),
            formEmailTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
            formEmailTextField.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: floatFormPadding),
            formEmailTextField.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: floatFormPadding * (-1)),
        ])

        formView.addSubview(formPasswordTextField)
        NSLayoutConstraint.activate([
            formPasswordTextField.topAnchor.constraint(equalTo: self.formEmailTextField.bottomAnchor, constant: floatFormPadding / 2),
            formPasswordTextField.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
            formPasswordTextField.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: floatFormPadding),
            formPasswordTextField.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: floatFormPadding * (-1)),
        ])

        formView.addSubview(formloginButton)
        NSLayoutConstraint.activate([
            formloginButton.bottomAnchor.constraint(equalTo: self.formView.bottomAnchor, constant: floatFormPadding * (-1)),
            formloginButton.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
            formloginButton.leadingAnchor.constraint(equalTo: self.formView.leadingAnchor, constant: floatFormPadding),
            formloginButton.trailingAnchor.constraint(equalTo: self.formView.trailingAnchor, constant: floatFormPadding * (-1)),
        ])

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

}

extension LoginViewController: UITextFieldDelegate {
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
}

//LOGIN & communicate with backend
extension LoginViewController {
    // process login
    
    func isCorrect() -> Bool {
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
                    
                    let nc = DashboardViewController()
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
