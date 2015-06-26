//
//  GeocoderTests.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/10/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import XCTest
import Halfway
import CoreLocation

public class GeocoderTests: XCTestCase {
    public func testGettingLatitudeAndLongitude() {
        var geocoder = Geocoder(address: "2650 Haste Street", city: "Berkeley", state: "CA")
        XCTAssertTrue(geocoder.getLatitude() == 37.8662874, "Gets correct latitude")
        XCTAssertTrue(geocoder.getLongitude() == -122.2552508, "Gets correct longitude")
    }
}
