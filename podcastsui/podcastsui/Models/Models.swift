//
//  Models.swift
//  podcastsui
//
//  Created by apple on 06.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SignInData: ObservableObject {
    @Published var email: String = "es@hnt.com"
    @Published var password: String = "123123"
}

class AppState: ObservableObject {
    
    struct NavState {
        var state: NavType
    }
    
    struct CurrentSession {
        var signedIn: Bool
        var user: ProfileObject?
        var loading: Bool
    }
    
    @Published var navigation = NavState(state: .splash)
    @Published var session = CurrentSession(
        signedIn: Helper.hasValue(forKey: "profile"),
        user: Helper.hasValue(forKey: "profile") ? (Helper.getObjectFromDefaults(returningClass: ProfileObject.self, forKey: "profile") as! ProfileObject) : nil,
        loading: false)
    
    public func login(profile: ProfileObject) {
        Helper.storeObjectInDefaults(profile, forKey: "profile")
        self.session.signedIn = true
        self.session.user = profile
        self.setState(.home)
    }
    public func logout() {
        Helper.removeValueFromUserDefaultsForKey(key: "profile")
        self.session.signedIn = false
        self.session.user = nil
        self.setState(.login)
    }
    
    public func setState(_ state: NavType) {
        withAnimation {
            self.navigation.state = state
        }
    }
    
    public func setLoading(_ loading: Bool) {
        self.session.loading = loading
    }
    
}

enum NavType: Hashable {
    case splash
    case login
    case home
    case profile
    case details
}
