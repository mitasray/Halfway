//
//  LocationTests.swift
//  HalfwayTests
//
//  Created by Mitas Ray on 6/3/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
import XCTest
import Halfway

public class LocationTests: XCTestCase {
    
    public func testInitializer() {
        var location = Location(latitude: 10, longitude: 10)
        XCTAssert(location.latitude() == 10, "Latitude is 10")
        XCTAssert(location.longitude() == 10, "Longitude is 10")
    }
    
    public func testGetHalfway() {
        var location1 = Location(latitude: 10, longitude: 10)
        var location2 = Location(latitude: 20, longitude: 20)
        var halfway = Location(latitude: 15, longitude: 15)
        var testResult = location1.halfway(location2)
        XCTAssert(halfway.latitude() == testResult.latitude(), "Expect latitude to be 15")
        XCTAssert(halfway.longitude() == testResult.longitude(), "Expect longitude to be 15")
    }
    
}
