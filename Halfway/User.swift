//
//  User.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/8/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation

public class User {
    
    public let user_id: Int
    public let username: String
    
    public init(username: String, user_id: Int) {
        self.user_id = user_id
        self.username = username
    }
}