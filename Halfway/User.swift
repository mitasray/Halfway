//
//  User.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/8/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import RealmSwift

public class User: Object {
    dynamic var id = 0
    dynamic var username = ""
    let friends = List<User>()
}