//
//  RoundedButtonView.swift
//  podcastsui
//
//  Created by apple on 03.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct RoundedButtonView: View {
    var title: String
    var color: Color = Theme.colorViolet
    var disabled: Bool? = false
    var onClick: (() -> Void)?

    var body: some View {
        Button(action: {self.onClick!()}) {
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .foregroundColor(Theme.colorWhite)
                Spacer()
            }
        }
        .padding(.vertical, 10.0)
        .background(color)
        .opacity(disabled! ? 0.2 : 1.0)
        .cornerRadius(5.0)
        .shadow(color: .black, radius: 5, x: 1, y: 1)
        .padding(.horizontal, 50)
        
    }
}

struct RoundedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonView(title: "Help Me", color: Theme.colorViolet)
    }
}
