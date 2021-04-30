//
//  TopBarView.swift
//  podcastsui
//
//  Created by apple on 13.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct TopBarView: View {
    
    @State var title: String = ""
    @State var leftButton: BImage = BImage()
    @State var rightButton: BImage = BImage()

    var onLeftClick: (() -> ())?
    var onRightClick: (() -> ())?
    
    var body: some View {
        HStack (alignment: .center) {
            
            ButtonImageView(bimage: leftButton, color: Theme.colorGrey, onClick: self.onLeft)
            .padding(.leading)
            Spacer()
            Text(title.uppercased())
                .foregroundColor(Theme.colorGrey)
                .fontWeight(.bold)
                .font(.title)
            Spacer()
            ButtonImageView(bimage: rightButton, color: Theme.colorGrey, onClick: self.onRight)
                .padding(.trailing)

        }
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .center)
        .background(Theme.colorTopbarBackground)
        .clipped()
        .shadow(color: Theme.colorBlack, radius: 4, x: 0, y: 2)
    }
    
    func onLeft(action: String) -> Void {
        self.onLeftClick!()
    }
    func onRight(action: String) -> Void {
        self.onRightClick!()
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView(title: "TEst", leftButton: BImage(name: "line.horizontal.3"), rightButton: BImage(name: "edit.svg", type: ImageType.svg))
    }
}
