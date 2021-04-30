//
//  ProfileView.swift
//  podcastsui
//
//  Created by apple on 17.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var store: AppState

    var body: some View {
        VStack {
            TopBarView(title: "Profile", leftButton: BImage(name: "chevron.left"), rightButton: BImage(name: "edit.svg", type: ImageType.svg), onLeftClick: self.onLeftClick, onRightClick: self.onRightClick)
                .padding(.bottom)
            Text("Profile")
                .foregroundColor(Theme.colorWhite)
            Spacer()
        }
    }
    
    func onLeftClick() -> Void {
        print("on left click")
        withAnimation {
            self.store.setState(.home)
        }
    }
    func onRightClick() -> Void {
        print("on right click")
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
