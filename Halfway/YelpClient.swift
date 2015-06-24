//
//  YelpClient.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/23/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation

let yelpConsumerKey = "5j9mbUKOpxkAsugIAhI5vw"
let yelpConsumerSecret = "e2NKNi7NLjubnMPGrjXChqDX-5c"
let yelpToken = "brQj6wDEEUY_D5cHskczigza3fHN50Jz"
let yelpTokenSecret = "f4PL09-I04apg086jUoC5J6M4JA"

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, parameters: Dictionary<String, String>? = nil, offset: Int = 0, limit: Int = 20, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        var params: NSMutableDictionary = [
            "term": term,
            "offset": offset,
            "limit": limit
        ]
        for (key, value) in parameters! {
            params.setValue(value, forKey: key)
        }
        println(self.GET("search", parameters: params, success: success, failure: failure))
        return self.GET("search", parameters: params, success: success, failure: failure)
    }
}
