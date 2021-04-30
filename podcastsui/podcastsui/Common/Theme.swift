//
//  Theme.swift
//  podcastsui
//
//  Created by apple on 14.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI

struct Theme {
    
    static var colorMainBackground: Color = Color(red: 26/255, green: 26/255, blue: 26/255, opacity: 1)
    static var colorTopbarBackground: Color = Color(red: 25/255, green: 25/255, blue: 25/255)
    static var colorTextFieldBackground = Color(red: 21/255, green: 21/255, blue: 21/255)
    // text
    static var colorGreyPlaceholder: Color = Color(red: 106/255, green: 106/255, blue: 106/255)
    static var colorWhite: Color = Color(red: 1, green: 1, blue: 1)
    static var colorBlack: Color = Color(red: 0, green: 0, blue: 0)
    static var colorGrey: Color = Color(red: 155/255, green: 155/255, blue: 155/255)
    static var colorLightGrey: Color = Color(red: 202/255, green: 202/255, blue: 202/255)
    static var colorDark: Color = Color(red: 33/255, green: 33/266, blue: 33/255)
    static var colorViolet: Color = Color(red: 153/255, green: 83/255, blue: 255/255)
    
    static func load(_ themeName: String? = "default") {
        if themeName == "blue" {
            loadBlue()
        } else if themeName == "red" {
            loadRed()
        } else {
            loadDefault()
        }
    }
    
    static private func loadDefault() -> Void {
        colorMainBackground = Color(red: 26/255, green: 26/255, blue: 26/255, opacity: 1)
        colorTopbarBackground = Color(red: 25/255, green: 25/255, blue: 25/255)
        colorTextFieldBackground = Color(red: 21/255, green: 21/255, blue: 21/255)
        // text
        colorWhite = Color(red: 1, green: 1, blue: 1)
        colorBlack = Color(red: 0, green: 0, blue: 0)
        colorGrey = Color(red: 155/255, green: 155/255, blue: 155/255)
        colorLightGrey = Color(red: 202/255, green: 202/255, blue: 202/255)
        colorDark = Color(red: 33/255, green: 33/266, blue: 33/255)
        colorViolet = Color(red: 153/255, green: 83/255, blue: 255/255)
    }
    
    static private func loadBlue() ->Void {
        colorMainBackground = Color(red: 26/255, green: 26/255, blue: 26/255, opacity: 1)
        colorTopbarBackground = Color(red: 25/255, green: 25/255, blue: 25/255)
        colorTextFieldBackground = Color(red: 21/255, green: 21/255, blue: 21/255)
        // text
        colorWhite = Color(red: 1, green: 1, blue: 1)
        colorBlack = Color(red: 0, green: 0, blue: 0)
        colorGrey = Color(red: 155/255, green: 155/255, blue: 155/255)
        colorLightGrey = Color(red: 202/255, green: 202/255, blue: 202/255)
        colorDark = Color(red: 33/255, green: 33/266, blue: 33/255)
        colorViolet = Color(red: 153/255, green: 83/255, blue: 255/255)
    }

    static private func loadRed() ->Void {
        colorMainBackground = Color(red: 26/255, green: 26/255, blue: 26/255, opacity: 1)
        colorTopbarBackground = Color(red: 25/255, green: 25/255, blue: 25/255)
        colorTextFieldBackground = Color(red: 21/255, green: 21/255, blue: 21/255)
        // text
        colorWhite = Color(red: 1, green: 1, blue: 1)
        colorBlack = Color(red: 0, green: 0, blue: 0)
        colorGrey = Color(red: 155/255, green: 155/255, blue: 155/255)
        colorLightGrey = Color(red: 202/255, green: 202/255, blue: 202/255)
        colorDark = Color(red: 33/255, green: 33/266, blue: 33/255)
        colorViolet = Color(red: 153/255, green: 83/255, blue: 255/255)
    }

}
