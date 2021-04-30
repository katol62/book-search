//
//  SideBarView.swift
//  podcastsui
//
//  Created by apple on 15.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//


import SwiftUI

struct MenuItem: Hashable, Identifiable {
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var label: String
    var action: String
    var button: BImage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SideBarView: View {
    
    let items: [MenuItem] = [
        MenuItem(label: "Profile", action: MenuType.profile, button: BImage(name: "user.svg", type: .svg)),
        MenuItem(label: "Shows", action: MenuType.shows, button: BImage(name: "venue.svg", type: .svg)),
        MenuItem(label: "Analytics", action: MenuType.analytics, button: BImage(name: "graph.svg", type: .svg)),
        MenuItem(label: "Notifications", action: MenuType.notifications, button: BImage(name: "notification.svg", type: .svg)),
        MenuItem(label: "Tech", action: MenuType.tech, button: BImage(name: "tech-vip.svg", type: .svg)),
        MenuItem(label: "Settings", action: MenuType.settings, button: BImage(name: "settings.svg", type: .svg)),
    ]
    
    var onMenuSelect: ((_ action: String) -> ())?
    
    var body: some View {
        VStack(alignment: .leading) {
            Group{
                ForEach(self.items, id: \.self.id) { item in
                    ButtonImageView(bimage: item.button, label: item.label, actionType: item.action, color: Theme.colorGrey, onClick: self.onSideBarSelect)
                    
                }
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.colorDark)
    }
    
    func onSideBarSelect(action: String) {
        print("action = \(action)")
        self.onMenuSelect!(action)
    }
}

extension SideBarView {
    
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
    }
}
