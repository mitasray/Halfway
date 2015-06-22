//
//  Result.swift
//  Halfway
//
//  Created by Mitas Ray on 6/21/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation

/**
* Class containing name, address, price, star, reviews, type.
* All data from single search result stored here.
*/
public class Result {
    public var name: String
    public var address: String
    public var cityStateZip: String
    public var price: String
    public var star: String
    public var reviews: String
    public var type: String
    public var phone: String
    
    public init(n: String, a: String, csz: String, pr: String, s: String, r: String, t: String, ph: String) {
        name = n
        address = a
        cityStateZip = csz
        price = pr
        star = s
        reviews = r
        type = t
        phone = ph
    }
}