//
//  SplashView.swift
//  podcastsui
//
//  Created by apple on 09.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var store: AppState

    var body: some View {
        BasicView() {
            ZStack {
                self.view(for: self.store.navigation.state)
                    .id(self.store.navigation.state)
                    .transition(.moveAndFade)
                    .animation(.easeInOut)
            }
        }
            .onAppear() {
                self.store.setLoading(true)
                print(self.store.navigation.state)
                print(self.store.session.loading)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.store.setLoading(false)
                    if self.store.session.signedIn {
                        withAnimation {
                            self.store.setState(.home)
                        }
                    } else {
                        withAnimation {
                            self.store.setState(.login)
                        }
                    }
                    print("Final: \(self.store.navigation.state)")
                }
            }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var store: AppState = AppState()
    static var previews: some View {
        SplashView()
        .environmentObject(store)
    }
}

extension SplashView {
    
    func view(for viewState: NavType) -> AnyView {
        print("viewState: \(viewState)")
        switch viewState {
        case .home:
            return AnyView(HomeView().environmentObject(store))
        case .login:
            return AnyView(LoginView().environmentObject(store))
        case .profile:
            return AnyView(ProfileView().environmentObject(store))
        case .details:
            return AnyView(ProfileView().environmentObject(store))
        case .splash:
            return AnyView(Text(""))
        }
    }

}
