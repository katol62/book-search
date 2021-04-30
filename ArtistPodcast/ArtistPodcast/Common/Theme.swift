//
//  Theme.swift
//  ArtistPodcast
//
//  Created by apple on 11.04.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    func colorFromHexString (hex:String, alpha: Float? = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha ?? 1.0)
        )
    }
}

struct Theme {
    
    static var colorTextBase = UIColor().colorFromHexString(hex: "ffffff")
    static var colorBackground = UIColor().colorFromHexString(hex: "1a1a1a")
    static var sidemenuColor = UIColor().colorFromHexString(hex: "212121")
    static var formTextfieldBackground = UIColor().colorFromHexString(hex: "151515")
    static var formButtonBackground = UIColor().colorFromHexString(hex: "9953ff")
    static var formPlaceholderColor = UIColor().colorFromHexString(hex: "6a6a6a")
    static var colorTopBar = UIColor().colorFromHexString(hex: "191919")
    static var colorMenu = UIColor().colorFromHexString(hex: "212121")
    static var colorGradientTop =  UIColor().colorFromHexString(hex: "222222")
    static var colorGradientBottom = UIColor().colorFromHexString(hex: "151515")
    static var colorMenuSelected = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.3)
    static var colorMenuSelectedSemitransparent = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.1)
    static var colorMenuSelectedTransparent = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.0)
    static var colorHeaderTitle = UIColor().colorFromHexString(hex: "9b9b9b")
    static var colorCellText = UIColor().colorFromHexString(hex: "cacaca")
    static var colorViolet = UIColor().colorFromHexString(hex: "b988ff")
    
    static func load(_ themeName: String? = "default") {
        if themeName == "blue" {
            loadBlue()
        } else if themeName == "red" {
            
        } else {
            loadDefault()
        }
    }

    static private func loadDefault() {
        colorTextBase = UIColor().colorFromHexString(hex: "ffffff")
        colorBackground = UIColor().colorFromHexString(hex: "1a1a1a")
        sidemenuColor = UIColor().colorFromHexString(hex: "212121")
        formTextfieldBackground = UIColor().colorFromHexString(hex: "151515")
        formButtonBackground = UIColor().colorFromHexString(hex: "9953ff")
        formPlaceholderColor = UIColor().colorFromHexString(hex: "6a6a6a")
        colorTopBar = UIColor().colorFromHexString(hex: "191919")
        colorMenu = UIColor().colorFromHexString(hex: "212121")
        colorGradientTop =  UIColor().colorFromHexString(hex: "222222")
        colorGradientBottom = UIColor().colorFromHexString(hex: "151515")
        colorMenuSelected = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.3)
        colorMenuSelectedSemitransparent = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.1)
        colorMenuSelectedTransparent = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.0)
        colorHeaderTitle = UIColor().colorFromHexString(hex: "9b9b9b")
        colorCellText = UIColor().colorFromHexString(hex: "cacaca")
        colorViolet = UIColor().colorFromHexString(hex: "b988ff")
    }
    
    static private func loadBlue() {
        colorTextBase = UIColor().colorFromHexString(hex: "ffffff")
        colorBackground = UIColor().colorFromHexString(hex: "004f7d")
        sidemenuColor = UIColor().colorFromHexString(hex: "212121")
        formTextfieldBackground = UIColor().colorFromHexString(hex: "151515")
        formButtonBackground = UIColor().colorFromHexString(hex: "9953ff")
        formPlaceholderColor = UIColor().colorFromHexString(hex: "6a6a6a")
        colorTopBar = UIColor().colorFromHexString(hex: "191919")
        colorMenu = UIColor().colorFromHexString(hex: "212121")
        colorGradientTop =  UIColor().colorFromHexString(hex: "011f3e")
        colorGradientBottom = UIColor().colorFromHexString(hex: "01114c")
        colorMenuSelected = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.3)
        colorMenuSelectedSemitransparent = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.1)
        colorMenuSelectedTransparent = UIColor().colorFromHexString(hex: "9953ff", alpha: 0.0)
        colorHeaderTitle = UIColor().colorFromHexString(hex: "9b9b9b")
        colorCellText = UIColor().colorFromHexString(hex: "cacaca")
        colorViolet = UIColor().colorFromHexString(hex: "b988ff")
    }

}
