//
//  Indicator.swift
//  podcastsui
//
//  Created by apple on 08.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct Indicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor

    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        if isAnimating {
            uiView.isHidden = false
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
            uiView.isHidden = true
        }
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        Indicator(isAnimating: .constant(true), style: .large, color: .black)
    }
}
