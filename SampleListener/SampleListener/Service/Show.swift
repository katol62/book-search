//
//  Show.swift
//  SampleListener
//
//  Created by apple on 21/09/2018.
//  Copyright © 2018 katol. All rights reserved.
//

import UIKit
import SwiftyJSON

class Show {

    var idShow : String!
    var Tittle : String!
    var AudioStream : String!
    var Status : String!
    var StartDate : String!
    var EndDate : String!
    var FirstName : String!
    var LastName : String!
    var AvailTime : String!

    init() {
        self.idShow = String()
        self.Tittle = String()
        self.AudioStream = String()
        self.Status = String()
        self.StartDate = String()
        self.EndDate = String()
        self.FirstName = String()
        self.LastName = String()
        self.AvailTime = String()
    }
    
    class func build(json:JSON) -> Show? {
        
        let show : Show = Show()
        
        show.idShow = json["idShow"].string != nil ? json["idShow"].string : ""
        show.Tittle = json["Tittle"].string != nil ? json["Tittle"].string : ""
        show.AudioStream = json["AudioStream"].string != nil ? json["AudioStream"].string : ""
        show.Status = json["Status"].string != nil ? json["Status"].string : ""
        show.StartDate = json["StartDate"].string != nil ? json["StartDate"].string : ""
        show.EndDate = json["EndDate"].string != nil ? json["EndDate"].string : ""
        show.FirstName = json["FirstName"].string != nil ? json["FirstName"].string : ""
        show.LastName = json["LastName"].string != nil ? json["LastName"].string : ""
        show.AvailTime = json["AvailTime"].string != nil ? json["AvailTime"].string : ""

        return show
    }
    
}
