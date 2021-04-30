//
//  HomeView.swift
//  podcastsui
//
//  Created by apple on 07.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppState
    @State var showMenu: Bool = false

    var body: some View {
        GeometryReader { geometry in
            BasicView() {
                ZStack(alignment: .leading) {
                    VStack {
                        TopBarView(title: "Shows", leftButton: BImage(name: "line.horizontal.3"), rightButton: BImage(name: "edit.svg", type: ImageType.svg), onLeftClick: self.onLeftClick, onRightClick: self.onRightClick)
                            .padding(.bottom)
                        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Theme.colorWhite)
                        Spacer()
                    }
                    if self.showMenu {
                        SideBarView(onMenuSelect: self.onSideMenuSelect)
                        .frame(width: geometry.size.width/3*2)
                        .shadow(color: Theme.colorBlack, radius: 5, x: 4, y: 0)
                        .transition(.move(edge: .leading))
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle("")
            }
        }
    }
    
    func onLeftClick() -> Void {
        print("on left click")
        withAnimation {
           self.showMenu = true
        }
    }
    func onRightClick() -> Void {
        print("on right click")
        self.store.logout()
    }
    
    func onSideMenuSelect(_ action: String) {
        print(action)
        withAnimation {
            self.showMenu = false
        }
        if action == MenuType.profile {
            self.store.setState(.profile)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        .environmentObject(AppState())
    }
}
