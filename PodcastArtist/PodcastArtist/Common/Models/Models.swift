//
//  Models.swift
//  PodcastArtist
//
//  Created by apple on 01.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit

struct NavConfig {
    var top: Bool!
    var side: Bool!
    init(top: Bool? = false, side: Bool? = false) {
        self.top = top
        self.side = side
    }
}

enum ShowsListType: Int {
    case active = 0
    case reaired
    case archive
}

enum ElementType {
    case text, description, datetime, location
}

struct Element {
    var title: String!
    var image: String!
    var type: ElementType!
    var editable: Bool!
    var expandable: Bool!
    init(title: String? = "", image: String? = "", editable: Bool? = false, expandable: Bool? = false, type: ElementType? = ElementType.text) {
        self.title = title!
        self.image = image!
        self.editable = editable!
        self.expandable = expandable!
        self.type = type!
    }
}
