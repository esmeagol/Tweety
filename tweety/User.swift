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
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as! NSString?
        screenname = dictionary["screen_name"] as! NSString?
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as! NSString?
        
    }

}
