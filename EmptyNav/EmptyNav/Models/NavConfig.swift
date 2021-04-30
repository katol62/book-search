//
//  NavConfig.swift
//  EmptyNav
//
//  Created by apple on 03/10/2019.
//  Copyright © 2019 custom. All rights reserved.
//

import Foundation

struct NavConfig {
    var barTop: Bar!
    var barBottom: Bar!
    init(top: Bar? = Bar(), bottom: Bar? = Bar()) {
        self.barTop = top
        self.barBottom = bottom
    }
}

struct Bar {
    var display : Bool
    var one : Bool
    var two : Bool
    
    init(display: Bool? = true, one: Bool? = true, second: Bool? = false) {
        self.display = display!
        self.one = one!
        self.two = second!
    }
}
