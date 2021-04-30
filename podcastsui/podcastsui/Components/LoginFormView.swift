//
//  LoginFormView.swift
//  podcastsui
//
//  Created by apple on 02.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct LoginFormView: View {
    
    @ObservedObject private var signinData: SignInData = SignInData()

    var onLogin: ((_ data: SignInData) -> ())?
    
    var body: some View {

        VStack {
            Text("Artist account")
                .foregroundColor(.white)
                .font(.headline)
                .padding()
            LabelTextView(value: $signinData.email, label: "EMAIL", placeholder: "Email")
            LabelTextView(value: $signinData.password, label: "PASSWORD", placeholder: "Password", secure: true)
            RoundedButtonView(title: "Login", color: Color.init(red: 153/255, green: 83/255, blue: 255/255), disabled: !self.isFormValid(), onClick: {self.onClick()})
                .disabled(!self.isFormValid())
            .padding()
        }
        .padding(.all, 20)
        .padding(.bottom, 30)
        .foregroundColor(Theme.colorWhite)
        .background(Theme.colorDark)
        .cornerRadius(15.0)
        .shadow(radius: 15.0)
        .shadow(color: Theme.colorBlack, radius: 5, x: 1, y: 1)
    }
    
    func onClick() {
        onLogin!(self.signinData)
    }
}

//form validation
extension LoginFormView {
    private func isFormValid() -> Bool {
        if signinData.email.isEmpty {
            return false
        }
        if signinData.password.isEmpty {
            return false
        }
        if !self.textFieldValidatorEmail(signinData.email) {
            return false
        }
        return true
    }
    
    private func textFieldValidatorEmail(_ string: String) -> Bool{
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}
