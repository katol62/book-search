//
//  Constants.swift
//  podcastsui
//
//  Created by apple on 06.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import Foundation

//REST API
let BASE_URL                = "https://www.hearnotthere.com/podCast/"
let LOGIN                   = "User/login"

//REST API PARAMETERS
let s_PROFILE = "profileObject"

let k_FIRST_LAUNCH = "FirstLaunch"

let k_FIRST_NAME = "FirstName"
let k_FULL_NAME = "FullName"
let k_LAST_NAME = "LastName"
let k_NAME = "Name"
let k_EMAIL = "Email"
let k_PASSWORD = "Password"
let k_DEVICE_TOKEN = "DeviceToken"
let k_DEVICE_TYPE = "DeviceType"
let k_USER_TYPE = "UserType"
let k_GENDER = "Gender"
let k_BIRTH_YEAR = "BirthYear"
let k_COUNTRY = "Country"
let k_STATE = "State"
let k_USER_ID = "idUser"
let k_PARENT_ID = "ParentId"
let k_MARKETING = "isMarketing"
let k_DJ_ID = "idDj"
let k_EMAIL_NOTIFY = "EmailNotify"
let k_TOTAL_TOKENS = "TotalToken"
let k_AGENT_ARTISTS = "artists"
let k_TOKEN = "token"
let k_TOKENS = "tokens"
let k_SHOW_TYPE = "showType"

let k_SEARCH_STR = "textSearch"

let k_TIMEZONE = "timeZone"
let k_TIMEZONE_ABBR = "timeZoneAbbr"

let k_COUNTRY_ID = "idCountry"
let k_TITLE = "Title"
let k_GENRES = "Genre"
let k_USER_DESCRIPTION = "Description"
let k_PROFILE_PIC = "Image"

let USER_TYPE_IS_DJ = "dj"
let USER_TYPE_IS_TECH = "tech"
let USER_TYPE_IS_USER = "user"

let k_SERVICE_STATUS = "status"
let SERVICE_STATUS_TRUE = "1"
let SERVICE_STATUS_FALSE = "0"

let k_SERVICE_MESSAGE = "message"
let k_SERVICE_DATA = "data"

let COUNTRY_CODE = "countryCode"


//strings
let strNetworkReachable = "reachable"
let strNetworkUnreachable = "unreachable"

// menu
struct MenuType {
    static let profile: String = "profile";
    static let shows: String = "shows";
    static let analytics: String = "analytics";
    static let notifications: String = "notifications";
    static let tech: String = "tech";
    static let settings: String = "settings";
}


