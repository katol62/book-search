//
//  RestClient.swift
//  ArtistPodcast
//
//  Created by apple on 19.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class RestClient: NSObject {

    static let shared = RestClient()
    
    class func get(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        if NetworkManager.sharedManager.isReachable == false{
            return
        }
        
        Alamofire.request(BASE_URL+serviceName, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 300
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
            }
        }
    }
    
    class func post(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        print(BASE_URL+serviceName)
        
        Alamofire.request(BASE_URL+serviceName, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 300
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
                
            }
        }
    }
    
    class func postMultiPart (serviceName:String, parameters:NSDictionary?, arrayImagesData:NSArray?, arrayFileNames: NSArray?, completionHandler: @escaping (JSON?, NSError?) -> ()){

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            // code
            
            for i in 0 ..< arrayFileNames!.count{
                
                multipartFormData.append(arrayImagesData![i] as! Data, withName: arrayFileNames![i] as! String, fileName: "file_pack", mimeType: "image/jpeg")
                
                for (key, value) in parameters! {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)! , withName: key as! String)
                }
            }
            
            
        }, to: URL.init(string: NSString(format: "%@%@","" as CVarArg, BASE_URL+serviceName) as String)!, encodingCompletion: { (result) in
            // code
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    
                    if let data = response.result.value{
                        let json = JSON(data)
                        completionHandler(json,nil)
                    }
                }
                
            case .failure(let encodingError):
                completionHandler(nil,encodingError as NSError)
                print(encodingError)
            }
        })

    }
}
