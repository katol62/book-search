//
//  Constants.swift
//  ArtistPodcast
//
//  Created by apple on 19.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit

//new UI constants

//floats
let floatTopBarHeight = CGFloat(70)
let loginFormPadding = CGFloat(54)
let floatSideMenuWidth = CGFloat(310)
let defaultNavButtonPadding = CGFloat(15)
let menuAnimateDuration = CGFloat(0.3)
let floatDashboardTopBarHeight = CGFloat(77)
let floatShowTableCellHeight: CGFloat = CGFloat(110)
let detailsElementHeight = CGFloat(64)
let floatLabelHeight: CGFloat = CGFloat(35)
let floatTextFieldHeight: CGFloat = CGFloat(44)
let floatTimeStackHeight: CGFloat = CGFloat(85)
let floatFormPadding: CGFloat = CGFloat(20)
let floatDetailsTabsHeight: CGFloat = CGFloat(84)
let floatDetailsTabsWidth: CGFloat = CGFloat(44)
let floatDetailsViewHeight: CGFloat = CGFloat(56)
let floatDetailsViewExpandedHeight: CGFloat = CGFloat(150)
let floatDetailsViewExpandedTextFieldHeight: CGFloat = CGFloat(120)
let floatDetailsViewExpandedTextViewHeight: CGFloat = CGFloat(190)
let floatBroadcatsViewHeight: CGFloat = CGFloat(200)
let floatPlayViewHeight: CGFloat = CGFloat(150)

//sizes
let iconButtonSize = CGSize(width: 25, height: 25)
let menuButtonSize = CGSize(width: 310, height: 44)
let loginFormSize = CGSize(width: 250, height: 310)
let loginLogoSize = CGSize(width: 175, height: 120)
let sidemenuLogoSize = CGSize(width: 147, height: 47)
let defaultNavButtonSize = CGSize(width: 30, height: 30)
let sizeDashboardTabButton = CGSize(width: 100, height: 48)
let sizeDetailsLabel = CGSize(width: 44, height: 30)
let sizeDetailsIcon: CGSize = CGSize(width: 25, height: 25)
let sizeDetailsViewIcon: CGSize = CGSize(width: 20, height: 20)
let sizeBroadcastButton: CGSize = CGSize(width: 100, height: 100)
let sizePlayBackground: CGSize = CGSize(width: 258, height: 94)
let sizePlayButton: CGSize = CGSize(width: 74, height: 74)
let sizeDurationButton: CGSize = CGSize(width: 100, height: 44)

//dictionaries
let menuArray = [[menuArrayTitles["Profile"]!,"user","user-pressed", Action.profile], [menuArrayTitles["Shows"]!,"venue","venue", Action.shows], [menuArrayTitles["Analytics"]!,"graph","graph-pressed", Action.analytics], [menuArrayTitles["Notifications"]!,"notification","notification-pressed", Action.notifications], [menuArrayTitles["Tech"]!,"tech-vip","tech-vip-pressed", Action.tech], [menuArrayTitles["Settings"]!,"settings","settings-pressed", Action.settings]]
let dashboardTabsArray = [["Upcoming", ShowsListType.active], ["Re-airing",ShowsListType.reaired], ["Archived",ShowsListType.archive]]

//strings
let strNetworkReachable = "reachable"
let strNetworkUnreachable = "unreachable"


