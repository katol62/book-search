//
//  PodcastConstants.swift
//  PodcastArtist
//
//  Created by apple on 06.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit

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
// MARK: Show

let k_SHOW_TITLE = "Tittle"
let k_SHOW_START_DATE_TIME = "StartDate"
let k_SHOW_START_DATE_FULL = "FullStartDate"
let k_SHOW_LIMIT = "AvailTime"
let k_SHOW_LOCATION_IN_WORDS = "Location"
let k_SHOW_COUNTRY_IN_WORDS = "Country"
let k_SHOW_STATE_IN_WORDS = "state"
let k_SHOW_TIME_ZONE_WORDS = "timeZone"
let k_SHOW_TOKENS = "Token"
let k_SHOW_VENUE = "Venue"
let k_SHOW_STATE = "state"
let k_SHOW_TAG_LINE = "TagLine"
let k_SHOW_DESCRIPTION = "Description"
let k_SHOW_ID = "idShow"
let K_SHOW_STATUS = "Status"
let K_SHOW_DURATION = "Duration"
let K_SHOW_AVAIL_TIME = "AvailTime"
let k_SHOW_DURATION = "ShowDuration"
let k_SHOW_HIDDEN = "hidden"
let k_SHOW_DONATE = "donate"
let k_SHOW_ARCHIVE = "archive"
let k_SHOW_TIME_ZONE_ABBR = "timeZoneAbbr"

let k_SHOW_STATUS = "Status"
let k_SHOW_STATUS_RUNNING = "live"

let k_SHOW_START_DATE = "ShowStartDate"
let k_SHOW_START_TIME = "ShowStartTime"

let K_STREAMING_PORT = "52.38.159.93" //"34.212.19.165"

let s_STREAMING_HOST = "52.38.159.93"
let s_STREAMING_PORT = Int32(8554)
let s_STREAMING_LICENCE = "DIV3-IAGB-G5TW-FX6J"

let a_SIDE_MENU_USER = NSMutableArray(array: [["home","Side-home"],["search shows","Side-search"],["profile","Side-profile"],["my shows","Side-shows"],["help","Side-help"],["logout","Side-logout"]])
let a_SIDE_MENU_DJ = NSMutableArray(array: [["home","Side-home"],["profile","Side-profile"],["go LIVE","Side-golive"],["shows","Side-shows"],["analytics","Side-analitics"],["archives","Side-archives"],["help","Side-help"],["logout","Side-logout"]])
let n_SIDE_MENU_TAG = 1000

let s_URL_TERMS = "https://www.hearnotthere.com/terms.html"
let s_URL_PRIVACY = "https://www.hearnotthere.com/privacypolicy.html"

let s_ADMIN_EMAIL = "admin@kevzo.com"

let s_TITLE_LIMIT = 120

let s_DESCRIPTION_LIMIT = 300

let a_BOTTOM_MENU_USER = NSMutableArray(array: [["Shows","UPD-icon-search","UPD-icon-search-selected"],["My Shows","UPD-icon-shows", "UPD-icon-shows-selected"],["Artists","UPD-icon-artist", "UPD-icon-artist-selected"], ["Help","UPD-icon-help","UPD-icon-help-selected"],["","UPD-icon-bar-user", "UPD-icon-bar-user-selected"]])

let a_BOTTOM_MENU_ADMIN = NSMutableArray(array: [["My Shows","UPD-icon-myshows","UPD-icon-myshows-selected"],["Analytics","UPD-icon-analytics", "UPD-icon-analytics-selected"],["Archives","UPD-icon-archives", "UPD-icon-archives-selected"], ["Help","UPD-icon-help","UPD-icon-help-selected"],["","UPD-icon-bar-user", "UPD-icon-bar-user-selected"]])

let s_BAR_TYPE_USER = "TypeUser"
let s_BAR_TYPE_ARTIST = "TypeArtist"

let c_COLOR_GREEN = UIColor(red: 0/255, green: 255/255, blue: 60/255, alpha: 1)
let c_COLOR_BLUE_LIGHT = UIColor(red: 173/255, green: 192/255, blue: 255/255, alpha: 1)
let c_COLOR_BLUE = UIColor(red: 102/255, green: 125/255, blue: 200/255, alpha: 1)
let c_COLOR_RED = UIColor(red: 255/255, green: 0/255, blue: 84/255, alpha: 1)

let n_CORNER_RADIUS = CGFloat(15)

let n_CORNER_RADIUS_PROFILE = CGFloat(8)

let s_SHOW_STATUS_RUNNING = "running"
let s_SHOW_STATUS_CANCEL = "cancel"
let s_SHOW_STATUS_LIVE = "live"
let s_SHOW_STATUS_END = "end"
let s_SHOW_STATUS_TIME_END = "timeEnd"

//
let n_RANGE_CREDIT_MIN = 0
let n_RANGE_CREDIT_MAX = 30

let s_ORDER_ASC = "ASC"
let s_ORDER_DESC = "DESC"

//TABS
var TAB_HEIGHT = CGFloat(60)
let BAR_TINT_COLOR = UIColor(red: 13/256, green: 18/256, blue: 47/256, alpha: 1)

let DEFAULT_LOCATION = "United States"

let CELL_WIDTH = CGFloat(170)
let CELL_HEIGNT = CGFloat(240)

let CELL_WIDTH_SMALL = CGFloat(150)
let CELL_HEIGNT_SMALL = CGFloat(211)

let GENRES_CELL_WIDTH_SMALL = CGFloat(120)
let GENRES_CELL_HEIGNT_SMALL = CGFloat(33)

let GENRES_CELL_WIDTH = CGFloat(150)
let GENRES_CELL_HEIGNT = CGFloat(65)

//"35.167.93.250" "35.162.172.141"
let SDKSampleAppLicenseKey = "GOSK-5C46-010C-99AB-0DD3-8D0F"


//REST API
let BASE_URL                = "https://www.hearnotthere.com/podCast/"

let LOGIN                   = "User/login"
let SIGNUP                  = "User/user"
let UPDATE_USER             = "User/updateProfile"
let FORGOT_PASSWORD         = "User/forgotPassword"
let CREATE_SHOW             = "Show/show"
let EDIT_SHOW               = "Show/editShow"
let LIST_OF_YOUR_SHOWS      = "Show/listShow"
let SHOW_ANALYTICS          = "Show/analyticsListShow"
let ARCHIVE_LIST            = "Show/archiveShowList"
let GO_LIVE_SHOW            = "Show/goLiveShow"
let SHOW_DETAILS            = "Show/detailShow"
let SHOW_DETAILS_BEFORE     = "Show/detailShowBeforeLogin"
let ARCHIVE_SHOW_DETAIL     = "Show/archiveShowDetail"
let SHOW_CANCEL             = "Show/cancelShow"
let GET_USER_PROFILE        = "User/getProfileById"
let UPDATE_DJ_PROFILE       = "User/updateProfile"
let SHOWS_AND_DJ_LIST       = "Show/usersShowList"
let GET_SEARCH_RESULTS      = "Show/usersShow"
let GET_SEARCH_UNAUTHORIZED = "Show/searchShow"
let USER_PURCHASE_SHOW      = "Show/goingShow"
let USER_CANCEL_SHOW        = "Show/cancelUserShow"
let GET_DJ_SHOWS_LIST       = "Show/listDjShows"
let GET_DJ_SHOWS_BEFORE     = "Show/listDjShowsBeforeLogin"
let USER_MY_SHOWS           = "Show/userBuyShow"
let SHOWS_LIST              = "Show/beforeLoginList"
let DJ_GO_LIVE              = "Show/goLive"
let USER_ENTERED            = "Show/enteredShow"
let PURCHASE_TOKEN          = "User/pToken"
let REPORT_ANALYTICS        = "Show/reportAnalytics"
let COUNTRIES               = "User/stateList"
let COUNTRY_LIST            = "User/countryList"
let EXISTS                  = "User/exists"
let GET_TECH_USERS          = "User/getTechUsers"
let DELETE_TECH_USER        = "User/deleteTechUser"
let SHOW_DONATE             = "User/donate"
let SHOW_WOWZA_RECORDINGS   = "Show/wowzaRecordings"
let SHOW_WOWZA_START_STOP   = "Show/startStopShow"
let SHOW_WOWZA_RECORDING    = "Show/getWowzaRecording"

let DJ_ADD_MERCHANDISE      = "User/merchandise"
let DJ_GET_MERCHANDISE      = "User/listMerchandise"
let DJ_GET_MUSIC            = "User/listMusic"

let REGISTER                = "User/register"
let GET_SHOWS               = "Show/getShowsList"
let GET_ARTISTS             = "Show/getArtistList"
let GET_SHOW_DETAILS        = "Show/detailClientShow"
let GET_STATES              = "Country/states"
let GET_PROFILE             = "User/getProfile"
let UPDATE_PROFILE          = "User/updateUserProfile"
let GET_ARTIST_SHOWS        = "Show/getArtistShowsList"
let GET_SHOWS_ARTISTS       = "Show/getShowsAndArtistList"
let SEARCH_SHOWS_LIST       = "Show/searchShowsList"
let GET_USER_SHOWS          = "Show/getUserShowsList"
let DISABLE_PROFILE         = "User/disableUserProfile"
let SAVE_SHOW               = "Show/saveShow"
let CLEAR_HISTORY           = "User/clearHistory"
let UPDATE_TIME             = "Show/updateTime"
let GET_SHOW_ANALYTICS      = "Show/showAnalytics"
let GET_ACTIVE_LISTENERS    = "Show/getActiveListeners"
let GET_LISTENERS_DATA      = "Show/getListenersWithData"
let UPDATE_FAVORITES        = "User/favorite"
let PICTURES_GET            = "Show/getPictures"
let PICTURES_ADD            = "Show/addPicture"
let PICTURES_DELETE         = "Show/deletePicture"

let GET_ADS                 = "Ads/ads"

