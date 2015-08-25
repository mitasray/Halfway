//
//  Event.swift
//  Halfway
//
//  Created by Kevin Arifin on 8/24/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {
    let invitedUsers = List<User>()
    dynamic var details = ""
    dynamic var date = NSDate()
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
}
