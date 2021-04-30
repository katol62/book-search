//
//  LoginView.swift
//  podcastsui
//
//  Created by apple on 29.06.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct LoginView: View {
    
    @EnvironmentObject var store: AppState
    
    var body: some View {
        BasicView() {
            ZStack {
                VStack {
                    LoginFormView(onLogin: self.onSubmit)
                        .padding(.all)
                    Spacer()
                }
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))

            }
        }
    }
    
    func onSubmit(_ data: SignInData) -> () {
        print("EMAIL: \(data.email )")
        print("PWD: \(data.password )")
        self.store.session.loading = true
        self.login(data)
    }
}

extension LoginView {
    private func login(_ data: SignInData) -> Void {
        let params : [String : String] =
            [k_EMAIL     : data.email,
             k_PASSWORD     : data.password,
             k_DEVICE_TOKEN : "123456789",
             k_DEVICE_TYPE  : "ios"]
        
        print(params)
        
        self.store.session.loading = true
        
        RestClient.shared.post(serviceName: LOGIN, parameters: params) { (json:JSON?, error:NSError?) in

            self.store.session.loading = false

            if error != nil {
                print(error?.localizedDescription ?? String())
                return
            } else {
                print(json!)
                if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_TRUE) {
                    
                    if json?["data"][k_USER_TYPE].stringValue != USER_TYPE_IS_DJ && json?["data"][k_USER_TYPE].stringValue != USER_TYPE_IS_TECH {
                        // not artist
                        return
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
                    
                    self.store.login(profile: decodedProfile)
                    
                        
                } else if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_FALSE) {
                    //server error
                }
            }
        }

    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        .environmentObject(AppState())
    }
}
