//
//  LabelTextView.swift
//  podcastsui
//
//  Created by apple on 29.06.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import SwiftUI

struct LabelTextView: View {
    
    @Binding var value: String {
        didSet {
            print("value: \(value)")
        }
    }
    var label: String
    var placeholder: String
    var secure: Bool! = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(label)
                .font(.headline)
                .padding(.top)
            
            ZStack(alignment: .leading) {
                Group {
                    if secure {
                        SecureField("", text: $value)
                        .padding(.all)
                            .foregroundColor(.white)
                            .background(Theme.colorTextFieldBackground)
                            .cornerRadius(10.0)
                    } else {
                        TextField("", text: $value)
                            .padding(.all)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                            .background(Theme.colorTextFieldBackground)
                            .cornerRadius(10.0)
                    }
                }
                if value.isEmpty { Text(placeholder)    .padding(.all)
                    .foregroundColor(Theme.colorGreyPlaceholder)
                    .background(Color.clear)
                }
            }
            
        }.padding(.horizontal, 15.0)
    }
    
    private func onEditingChanged() {
        print(value)
    }
}

struct LabelTextView_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextView(value: .constant("aaa"), label: "My Name", placeholder: "Placeholder", secure: false)
    }
}
