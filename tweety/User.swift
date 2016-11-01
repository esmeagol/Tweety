//
//  User.swift
//  tweety
//
//  Created by Abhinav Rai on 10/31/16.
//  Copyright © 2016 Abhinav Rai. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as! NSString?
        screenname = dictionary["screen_name"] as! NSString?
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as! NSString?
        
    }
    
    static var _currentUser: User?
    class var currentUser : User? {
        get {
            if _currentUser == nil {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? NSData
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                _currentUser = User(dictionary: dictionary as! NSDictionary)
            }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                print ("test1")
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                print ("test2")
                defaults.set(data, forKey: "currentUserData")

            } else {
                defaults.set(nil, forKey: "currentUserData")

            }
            
            defaults.synchronize()

        }
    }

}
