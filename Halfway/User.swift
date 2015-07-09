//
//  User.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/8/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation

public class User {
    
    public let username: String
    public let access_token: String
    
    public init(username: String, access_token: String) {
        self.username = username
        self.access_token = access_token
    }
}