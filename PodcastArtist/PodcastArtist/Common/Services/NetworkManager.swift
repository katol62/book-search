//
//  NetworkManager.swift
//  PodcastArtist
//
//  Created by apple on 06.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

open class NetworkManager {
    
    public static var sharedManager: NetworkReachabilityManager = {
        
        let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
        
        reachabilityManager?.listener = { (status) in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: strNetworkUnreachable), object: nil)
                
            case .unknown :
                print("It is unknown wether the network is reachable")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: strNetworkUnreachable), object: nil)

            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: strNetworkReachable), object: nil)
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: strNetworkReachable), object: nil)
            }
        }
        
        reachabilityManager?.startListening()
        return reachabilityManager!
    }()
}
