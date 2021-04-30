//
//  BasicView.swift
//  podcastsui
//
//  Created by apple on 07.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct BasicView<Content>: View where Content: View {
    
    @EnvironmentObject var store: AppState

    private let content: Content
    var showTopBar: Bool = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView() {
            ZStack(alignment: .center) {
                Theme.colorMainBackground
                    .edgesIgnoringSafeArea(.all)
                content
                VStack {
                    Indicator(isAnimating: $store.session.loading, style: .large, color: .white)
                }
                .background(Color.clear)
                .foregroundColor(Theme.colorWhite)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
        .environmentObject(store)

    }
}

struct BasicView_Previews: PreviewProvider {
    static var previews: some View {
        BasicView() {
            LoginView()
            .environmentObject(AppState())
        }
        .environmentObject(AppState())
    }
}
