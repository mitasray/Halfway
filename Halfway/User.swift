//
//  User.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/8/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var username = ""
    dynamic var email = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    let friends = List<User>()
    let events = List<Event>()
}