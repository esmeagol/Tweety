//
//  twitterClient.swift
//  tweety
//
//  Created by Abhinav Rai on 10/31/16.
//  Copyright © 2016 Abhinav Rai. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")! as URL!, consumerKey: "tQLG5nayawqbPIWzWpSLk5EgR", consumerSecret: "7rgycnE9UCXS482RXQIMvCsxccafUddTGjHILVqMXtByYvt9Xy")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let token = (requestToken?.token)! as String
            
            if let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)") {
                print(url)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            } else {
                print("did not get url")
            }
            }, failure: { (error:Error?) in
                print ("error: \(error!.localizedDescription)")
                self.loginFailure?(error as! NSError)
        })

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error:NSError) in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })

        
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
                //print("account: \(response)")
                let dictionaries = response as! [NSDictionary]
            
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
                success(tweets)
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error as NSError)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            print("name: \(user.name!)")
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            failure(error as NSError)
        })
    }

}
