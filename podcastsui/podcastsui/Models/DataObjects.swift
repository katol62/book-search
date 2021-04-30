//
//  DataObjects.swift
//  podcastsui
//
//  Created by apple on 07.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileObject : Codable {
    
    var Title : String!
    var idUser : String!
    var Image : String!
    var Password : String!
    var BirthYear : String!
    var LastName : String!
    var Gender : String!
    var isMarketing : String!
    var FirstName : String!
    var State : String!
    var merchandise : String!
    var CountryCode : String!
    var timeZone : String!
    var timeZoneAbbr : String!
    var utc_offset : String!
    var Email : String!
    var Country : String!
    var DeviceToken : String!
    var Description : String!
    var social : [String: String]!
    var music : String!
    var TotalToken : String!
    var UserType : String!
    var Age : String!
    var Genre : String!
    var DeviceType : String!
    var EmailNotify : String!
    var ParentId : String!
    var artists : [String]!
    var Favorite : String!

    init() {
        self.Title = String()
        self.idUser = String()
        self.Image = String()
        self.Password = String()
        self.BirthYear = String()
        self.LastName = String()
        self.Gender = String()
        self.isMarketing = String()
        self.FirstName = String()
        self.State = String()
        self.merchandise = String()
        self.CountryCode = String()
        self.timeZone = String()
        self.timeZoneAbbr = String()
        self.utc_offset = String()
        self.Email = String()
        self.Country = String()
        self.DeviceToken = String()
        self.Description = String()
        self.social = [String:String]()
        self.music = String()
        self.TotalToken = String()
        self.UserType = String()
        self.Age = String()
        self.Genre = String()
        self.DeviceType = String()
        self.EmailNotify = String()
        self.ParentId = String()
        self.artists = [String]()
        self.Favorite = "0"
    }
    
    class func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    class func convertToArray(text: String) -> [String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    class func build(json:JSON) -> ProfileObject? {
        
        let profile : ProfileObject = ProfileObject()
        
        profile.Title = json["Title"].string != nil ? json["Title"].string : ""
        profile.idUser = json["idUser"].string != nil ? json["idUser"].string : ""
        profile.Image = json["Image"].string != nil ? json["Image"].string : ""
        profile.Password = json["Password"].string != nil ? json["Password"].string : ""
        profile.BirthYear = json["BirthYear"].string != nil ? json["BirthYear"].string : ""
        profile.LastName = json["LastName"].string != nil ? json["LastName"].string : ""
        profile.Gender = json["Gender"].string != nil ? json["Gender"].string : ""
        profile.isMarketing = json["isMarketing"].string != nil ? json["isMarketing"].string : ""
        profile.FirstName = json["FirstName"].string != nil ? json["FirstName"].string : ""
        profile.State = json["State"].string != nil ? json["State"].string : ""
        profile.merchandise = json["merchandise"].string != nil ? json["merchandise"].string : ""
        profile.CountryCode = json["CountryCode"].string != nil ? json["CountryCode"].string : ""
        profile.timeZone = json["timeZone"].string != nil ? json["timeZone"].string : ""
        profile.timeZoneAbbr = json["timeZoneAbbr"].string != nil ? json["timeZoneAbbr"].string : "UTC"
        profile.utc_offset = json["utc_offset"].string != nil ? json["utc_offset"].string : "0"
        profile.Email = json["Email"].string != nil ? json["Email"].string : ""
        profile.Country = json["Country"].string != nil ? json["Country"].string : ""
        profile.DeviceToken = json["DeviceToken"].string != nil ? json["DeviceToken"].string : ""
        profile.Description = json["Description"].string != nil ? json["Description"].string : ""
        profile.social = json["social"].string != nil ? ProfileObject.convertToDictionary(text: json["social"].stringValue) : [String: String]()
        profile.music = json["music"].string != nil ? json["music"].string : ""
        profile.TotalToken = json["TotalToken"].string != nil ? json["TotalToken"].string : ""
        profile.Genre = json["Genre"].string != nil ? json["Genre"].string : ""
        profile.UserType = json["UserType"].string != nil ? json["UserType"].string : ""
        profile.Age = json["Age"].string != nil ? json["Age"].string : ""
        profile.DeviceType = json["DeviceType"].string != nil ? json["DeviceType"].string : ""
        profile.EmailNotify = json["EmailNotify"].string != nil ? json["EmailNotify"].string : "0"
        profile.ParentId = json["ParentId"].string != nil ? json["ParentId"].string : ""
        profile.Favorite = json["Favorite"].string != nil ? json["Favorite"].string : "0"
        profile.artists = json["artists"].string != nil ? ProfileObject.convertToArray(text: json["artists"].stringValue) : [String]()

        return profile
    }
    
    class func copy(o : ProfileObject) -> ProfileObject {
        let profile : ProfileObject = ProfileObject()

        profile.Title = o.Title
        profile.idUser = o.idUser
        profile.Image = o.Image
        profile.Password = o.Password
        profile.BirthYear = o.BirthYear
        profile.LastName = o.LastName
        profile.Gender = o.Gender
        profile.isMarketing = o.isMarketing
        profile.FirstName = o.FirstName
        profile.State = o.State
        profile.merchandise = o.merchandise
        profile.CountryCode = o.CountryCode
        profile.timeZone = o.timeZone
        profile.timeZoneAbbr = o.timeZoneAbbr
        profile.utc_offset = o.utc_offset
        profile.Email = o.Email
        profile.Country = o.Country
        profile.DeviceToken = o.DeviceToken
        profile.Description = o.Description
        profile.social = o.social
        profile.music = o.music
        profile.TotalToken = o.TotalToken
        profile.Genre = o.Genre
        profile.UserType = o.UserType
        profile.Age = o.Age
        profile.DeviceType = o.DeviceType
        profile.EmailNotify = o.EmailNotify
        profile.ParentId = o.ParentId
        profile.Favorite = o.Favorite
        profile.artists = o.artists
        
        return profile

    }
}


