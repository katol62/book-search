//
//  Helper.swift
//  podcastsui
//
//  Created by apple on 07.07.2020.
//  Copyright © 2020 com.livestreamtonight. All rights reserved.
//

import Foundation

class Helper: NSObject {
    
    //STORED DATA
    class func hasValue(forKey key: String) -> Bool {
        return nil != UserDefaults.standard.value(forKey: key)
    }
    class func setValueInUserDefaults(value: String, forKey key: String)
    {
        UserDefaults.standard.set(value, forKey: key)
    }
    class func getValueFromUserDefaultsForKey(key: String) -> String
    {
        return UserDefaults.standard.value(forKey: key) as! String
    }
    class func removeValueFromUserDefaultsForKey(key: String)
    {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    class func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    class func storeObjectInDefaults<T : Codable> (_ object: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    class func getObjectFromDefaults<T : Codable> (returningClass : T.Type, forKey key: String) -> Any? {
        let data = UserDefaults.standard.data(forKey: key)
        let objectData = try? JSONDecoder().decode(returningClass.self, from: data!)
        return(objectData)
    }

}
