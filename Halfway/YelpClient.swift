//
//  YelpClient.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/24/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import OAuthSwift

public class YelpClient {
    var client: OAuthSwiftClient
    let params: [String: String] = [
        "location": "San+Francisco",
        "term": "seafood"
    ]
    var json: NSDictionary = NSDictionary()
    
    public init() {
        client = OAuthSwiftClient(
            consumerKey: "5j9mbUKOpxkAsugIAhI5vw",
            consumerSecret: "e2NKNi7NLjubnMPGrjXChqDX-5c",
            accessToken: "brQj6wDEEUY_D5cHskczigza3fHN50Jz",
            accessTokenSecret: "f4PL09-I04apg086jUoC5J6M4JA"
        )
    }
    
    public func getJSON() -> NSDictionary {
        client.get(
            "https://api.yelp.com/v2/search",
            parameters: params,
            success: { (data, response) -> Void in
                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                self.saveJSON(json)
            },
            failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
            }
        )
        return self.json
    }
    
    private func saveJSON(json: NSDictionary) {
        self.json = json
    }
}




