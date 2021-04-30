//
//  ShowObject.swift
//  DJ Podcast
//
//  Created by apple on 03/07/2018.
//

import UIKit
import SwiftyJSON

//SHOW
class ShowObject {
    
    var ShowDuration : String!
    var Tittle : String!
    var idShow : String!
    var audioStreaming : String!
    var idUser : String!
    var Image : String!
    var hidden : String!
    var donate : String!
    var agent : String!
    var LastName : String!
    var FullStartDate : String!
    var Location : String!
    var Longitude : String!
    var FirstName : String!
    var state : String!
    var StartDate : String!
    var LocationCode : String!
    var timeZone : String!
    var Token : String!
    var shortCode : String!
    var timeZoneID : String!
    var TagLine : String!
    var Description : String!
    var Latitude : String!
    var Venue : String!
    var AvailTime : String!
    var Genre : String!
    var FullEndDate : String!
    var Status : String!
    var EndDate : String!
    var isBuy : String!
    var archive : String!
    var pictures : String!
    var wowza_stream_name: String!
    var wowza_stream_id: String!
    var wowza_stream_record: String!

    init(){
        self.ShowDuration = String()
        self.Tittle = String()
        self.idShow = String()
        self.audioStreaming = String()
        self.idUser = String()
        self.Image = String()
        self.hidden = "0"
        self.donate = "0"
        self.agent = "0"
        self.LastName = String()
        self.FullStartDate = String()
        self.Location = String()
        self.Longitude = String()
        self.FirstName = String()
        self.state = String()
        self.StartDate = String()
        self.LocationCode = String()
        self.timeZone = String()
        self.Token = String()
        self.shortCode = String()
        self.timeZoneID = String()
        self.TagLine = String()
        self.Description = String()
        self.Latitude = String()
        self.Venue = String()
        self.AvailTime = String()
        self.Genre = String()
        self.FullEndDate = String()
        self.Status = String()
        self.EndDate = String()
        self.isBuy = String()
        self.archive = "1"
        self.pictures = "0"
        self.wowza_stream_name = String()
        self.wowza_stream_id = String()
        self.wowza_stream_record = String()
    }
    
    class func build(json:JSON) -> ShowObject? {
        
        let show : ShowObject = ShowObject()
        
        show.ShowDuration = json["ShowDuration"].string != nil ? json["ShowDuration"].string : ""
        show.Tittle = json["Tittle"].string != nil ? json["Tittle"].string : ""
        show.idShow = json["idShow"].string != nil ? json["idShow"].string : ""
        show.audioStreaming = json["audioStreaming"].string != nil ? json["audioStreaming"].string : ""
        show.idUser = json["idUser"].string != nil ? json["idUser"].string : ""
        show.Image = json["Image"].string != nil ? json["Image"].string : ""
        show.hidden = json["hidden"].string != nil ? json["hidden"].string : "0"
        show.donate = json["donate"].string != nil ? json["donate"].string : "0"
        show.agent = json["agent"].string != nil ? json["agent"].string : "0"
        show.LastName = json["LastName"].string != nil ? json["LastName"].string : ""
        show.FullStartDate = json["FullStartDate"].string != nil ? json["FullStartDate"].string : ""
        show.Location = json["Location"].string != nil ? json["Location"].string : ""
        show.Longitude = json["Longitude"].string != nil ? json["Longitude"].string : ""
        show.FirstName = json["FirstName"].string != nil ? json["FirstName"].string : ""
        show.state = json["state"].string != nil ? json["state"].string : ""
        show.StartDate = json["StartDate"].string != nil ? json["StartDate"].string : ""
        show.LocationCode = json["LocationCode"].string != nil ? json["LocationCode"].string : ""
        show.timeZone = json["timeZoneId"].string != nil ? json["timeZoneId"].string : ""
        show.Token = json["Token"].string != nil ? json["Token"].string : ""
        show.shortCode = json["shortCode"].string != nil ? json["shortCode"].string : ""
        show.timeZoneID = json["timeZoneID"].string != nil ? json["timeZoneID"].string : ""
        show.TagLine = json["TagLine"].string != nil ? json["TagLine"].string : ""
        show.Description = json["Description"].string != nil ? json["Description"].string : ""
        show.Latitude = json["Latitude"].string != nil ? json["Latitude"].string : ""
        show.Venue = json["Venue"].string != nil ? json["Venue"].string : ""
        show.AvailTime = json["AvailTime"].string != nil ? json["AvailTime"].string : ""
        show.Genre = json["Genre"].string != nil ? json["Genre"].string : ""
        show.FullEndDate = json["FullEndDate"].string != nil ? json["FullEndDate"].string : ""
        show.Status = json["Status"].string != nil ? json["Status"].string : ""
        show.EndDate = json["EndDate"].string != nil ? json["EndDate"].string : ""
        show.isBuy = json["isBuy"].string != nil ? json["isBuy"].string : "0"
        show.archive = json["archive"].string != nil ? json["archive"].string : "1"
        show.pictures = json["pictures"].string != nil ? json["pictures"].string : "0"
        show.wowza_stream_name = json["wowza_stream_name"].string != nil ? json["wowza_stream_name"].string : ""
        show.wowza_stream_id = json["wowza_stream_id"].string != nil ? json["wowza_stream_id"].string : ""
        show.wowza_stream_record = json["wowza_stream_record"].string != nil ? json["wowza_stream_record"].string : ""

        return show
    }
    
    class func copy(from: ShowObject) ->ShowObject {
        let show : ShowObject = ShowObject()
        
        show.ShowDuration = from.ShowDuration
        show.Tittle = from.Tittle
        show.idShow = from.idShow
        show.audioStreaming = from.audioStreaming
        show.idUser = from.idUser
        show.Image = from.Image
        show.hidden = from.hidden
        show.donate = from.donate
        show.agent = from.agent
        show.LastName = from.LastName
        show.FullStartDate = from.FullStartDate
        show.Location = from.Location
        show.Longitude = from.Longitude
        show.FirstName = from.FirstName
        show.state = from.state
        show.StartDate = from.StartDate
        show.LocationCode = from.LocationCode
        show.timeZone = from.timeZone
        show.Token = from.Token
        show.shortCode = from.shortCode
        show.timeZoneID = from.timeZoneID
        show.TagLine = from.TagLine
        show.Description = from.Description
        show.Latitude = from.Latitude
        show.Venue = from.Venue
        show.AvailTime = from.AvailTime
        show.Genre = from.Genre
        show.FullEndDate = from.FullEndDate
        show.Status = from.Status
        show.EndDate = from.EndDate
        show.isBuy = from.isBuy
        show.archive = from.archive
        show.pictures = from.pictures
        show.wowza_stream_name = from.wowza_stream_name
        show.wowza_stream_id = from.wowza_stream_id
        show.wowza_stream_record = from.wowza_stream_record

        return show

    }
    
    class func compare(first : ShowObject, second: ShowObject) -> Bool {
        return (first.ShowDuration == second.ShowDuration && first.Tittle == second.Tittle && first.hidden == second.hidden && first.donate == second.donate && first.StartDate == second.StartDate && first.AvailTime == second.AvailTime && first.state == second.state && first.Location == second.Location && first.timeZone == second.timeZone && first.timeZoneID == second.timeZoneID && first.Description == second.Description && first.TagLine == second.TagLine && first.ShowDuration == second.ShowDuration && first.archive == second.archive && first.Venue == second.Venue)
    }

}

class PictureObject {
    var idShow : String!
    var image : String!
    var imageUrl : String!

    init() {
        self.idShow = ""
        self.image = ""
        self.imageUrl = ""
    }
    
    class func build(json:JSON) -> PictureObject? {
        let picture : PictureObject = PictureObject()
        picture.idShow = json["idShow"].string != nil ? json["idShow"].string : ""
        picture.image = json["image"].string != nil ? json["image"].string : ""
        picture.imageUrl = json["imageUrl"].string != nil ? json["imageUrl"].string : ""
        return picture
    }
    
}

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

class Social {
    var image:String!
    var url:String!
    
    init(image: String?, url: String?) {
        self.image = image
        self.url = url
    }
}

class SocialObject {
    var account : String!
    var link : String!
    var image : String!
    
    init() {
        self.account = String()
        self.link = String()
        self.image = String()
    }
    
    init(account: String?, link: String?) {
        self.account = account
        self.link = link
        self.image = String()
    }

    init(account: String?, link: String?, image: String?) {
        self.account = account
        self.link = link
        self.image = image
    }

}

