//
//  ButtonImageView.swift
//  podcastsui
//
//  Created by apple on 14.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

enum ImageType {
    case normal, system, svg
}

struct BImage {
    var name: String
    var type: ImageType
    init() {
        self.name = ""
        self.type = ImageType.system
    }
    
    init(name: String) {
        self.name = name
        self.type = ImageType.system
    }
    init(name: String, type: ImageType) {
        self.name = name
        self.type = type
    }
}


struct ButtonImageView: View {
    @State var bimage: BImage
    @State var label: String = ""
    @State var actionType: String = "any"
    @State var color: Color = .primary
    @State var size: Int = 30
    
    var onClick: ((_ action: String) -> Void)?

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Button(action: {
                self.onClick!(self.actionType)
            }) {
                HStack(alignment: .center, spacing: 5) {
                    Group {
                        if bimage.type == ImageType.system {
                            Image(systemName: bimage.name)
                                .font(.system(size: CGFloat(size)))
                        } else if bimage.type == ImageType.svg {
                            SVGImageView(name: bimage.name, color: color)
                                .frame(width: CGFloat(size), height: CGFloat(size), alignment: .center)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(color)

                        } else {
                            ZStack {
                                Image(bimage.name)
                                    .frame(width: CGFloat(size), height: CGFloat(size), alignment: .center)
                                    .foregroundColor(color)
                                    .font(.system(size: CGFloat(size)))
                            }
                        }
                    }
                    if label != "" {
                        Text(label)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .font(.system(size: CGFloat(size*3/4)))
                        .foregroundColor(color)
                    }

                }
            }
            .foregroundColor(color)
        }
        .foregroundColor(color)
    }
    
}

struct ButtonImageView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonImageView(bimage: BImage(name: "edit.svg", type: ImageType.normal), label: "Label", color: Theme.colorGrey)
    }
}
