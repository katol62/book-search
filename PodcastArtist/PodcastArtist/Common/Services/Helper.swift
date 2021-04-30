//
//  StoreHelper.swift
//  PodcastArtist
//
//  Created by apple on 06.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import Foundation
import UIKit

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
    
    class func setImage(image: UIImage?, quality: CGFloat = 0.5, forKey defaultName: String) {
        guard let image = image else {
             UserDefaults.standard.set(nil, forKey: defaultName)
            return
        }
         UserDefaults.standard.set(image.jpegData(compressionQuality: quality), forKey: defaultName)
    }
    class func getImage(forKey defaultName:String) -> UIImage? {
        guard
            let data =  UserDefaults.standard.data(forKey: defaultName),
            let image = UIImage(data: data)
            else  { return nil }
        return image
    }
    
    class func removeReference() {
        if self.hasValue(forKey: s_PROFILE) {
            self.removeValueFromUserDefaultsForKey(key: s_PROFILE)
        }
        if self.hasValue(forKey: k_USER_ID) {
            self.removeValueFromUserDefaultsForKey(key: k_USER_ID)
        }
        if self.hasValue(forKey: k_USER_TYPE) {
            self.removeValueFromUserDefaultsForKey(key: k_USER_TYPE)
        }
        if self.hasValue(forKey: k_EMAIL) {
            self.removeValueFromUserDefaultsForKey(key: k_EMAIL)
        }
        if self.hasValue(forKey: k_PASSWORD) {
            self.removeValueFromUserDefaultsForKey(key: k_PASSWORD)
        }
        if self.hasValue(forKey: k_AGENT_ARTISTS) {
            self.removeValueFromUserDefaultsForKey(key: k_AGENT_ARTISTS)
        }
        if self.hasValue(forKey: k_FULL_NAME) {
            self.removeValueFromUserDefaultsForKey(key: k_FULL_NAME)
        }
        if self.hasValue(forKey: k_PROFILE_PIC) {
            self.removeValueFromUserDefaultsForKey(key: k_PROFILE_PIC)
        }
        if self.hasValue(forKey: k_FIRST_NAME) {
            self.removeValueFromUserDefaultsForKey(key: k_FIRST_NAME)
        }
        if self.hasValue(forKey: k_LAST_NAME) {
            self.removeValueFromUserDefaultsForKey(key: k_LAST_NAME)
        }
        if self.hasValue(forKey: k_LAST_NAME) {
            self.removeValueFromUserDefaultsForKey(key: k_SHOW_TIME_ZONE_WORDS)
        }
    }
    
    //MISC
    class func isValidEmail(testStr:String) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func DateTimeFormat(date:String, format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard dateFormatter.date(from: date) != nil else {
            return date
        }
        let dt = dateFormatter.date(from: date)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: dt!)
    }


}
