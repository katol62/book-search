//
//  Models.swift
//  ArtistPodcast
//
//  Created by apple on 19.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit

enum ShowsListType: Int {
    case active = 0, reaired, archive
}

enum MenuState {
    case hidden, shown
}

enum Action: String {
    case none, profile, shows, analytics, notifications, tech, settings, logout
}

enum Duration: Int {
    case less = 50, middle, more
}

enum DetailType {
    case label, textfield, textarea, datetime, location
}
