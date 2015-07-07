//
//  HalfwayBrainTests.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/10/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import XCTest
import Halfway
import CoreLocation

public class HalfwayBrainTests: XCTestCase {
    var testLocation1 = CLLocation(latitude: 0, longitude: 0)
    var testLocation2 = CLLocation(latitude: 10, longitude: 10)
    
    public func testSetCurrentLocation() {
        var brain = HalfwayBrain(currentLocation: testLocation1, targetLocation: testLocation2)
        var location = CLLocation(latitude: 15, longitude: 15)
        brain.setCurrentLocation(location)
        XCTAssertEqual(location, brain.getCurrentLocation(), "current location is set to new location")
    }
    
    public func testSetTargetLocation() {
        var brain = HalfwayBrain(currentLocation: testLocation1, targetLocation: testLocation2)
        var location = CLLocation(latitude: 15, longitude: 15)
        brain.setTargetLocation(location)
        XCTAssertEqual(location, brain.getTargetLocation(), "current location is set to new location")
    }
    
    public func testCalculateHalfwayLocation() {
        var brain = HalfwayBrain(currentLocation: testLocation1, targetLocation: testLocation2)
        var halfwayLocation = brain.calculateHalfwayLocation()
        var expectedHalfwayLocation = CLLocation(latitude: 5, longitude: 5)
        XCTAssertEqual(halfwayLocation.coordinate.longitude, halfwayLocation.coordinate.longitude, "halfway longitude is calculated correctly")
        XCTAssertEqual(halfwayLocation.coordinate.latitude, halfwayLocation.coordinate.latitude, "halfway latitude is calculated correctly")
    }
}