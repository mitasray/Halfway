//
//  HalfwayBrain.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/10/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import CoreLocation

public class HalfwayBrain {
    var currentLocation: CLLocation
    var targetLocation: CLLocation
    var targetLocations: [CLLocation] = [CLLocation]()
    
    public init() {
        self.currentLocation = CLLocation(latitude: 0, longitude: 0)
        self.targetLocation = CLLocation(latitude: 0, longitude: 0)
    }
    
    public init(currentLocation: CLLocation, targetLocation: CLLocation) {
        self.currentLocation = currentLocation
        self.targetLocation = targetLocation
    }
    
    public func setCurrentLocation(newLocation: CLLocation) -> Void {
        self.currentLocation = newLocation
    }
    
    public func getCurrentLocation() -> CLLocation {
        return self.currentLocation
    }
    
    public func setTargetLocation(newLocation: CLLocation) -> Bool {
        for targetLocation: CLLocation in targetLocations {
            if equal(targetLocation, loc2: newLocation) {
                return false
            }
        }
        targetLocations.append(newLocation)
        self.targetLocation = newLocation
        return true
    }
    
    public func getTargetLocation() -> CLLocation {
        return self.targetLocations[targetLocations.count - 1]
    }
    
    public func calculateHalfwayLocation() -> CLLocation {
        var totLat = latitudeFor(currentLocation)
        var totLong = longitudeFor(currentLocation)
        var count: Double = 1
        for loc: CLLocation in targetLocations {
            totLat += latitudeFor(loc)
            totLong += longitudeFor(loc)
            count += 1
        }
        var latitude = totLat / count
        var longitude = totLong / count
        var halfwayLocation = CLLocation(latitude: latitude, longitude: longitude)
        return halfwayLocation
    }
    
    private func latitudeFor(location: CLLocation) -> Double {
        return location.coordinate.latitude
    }
    
    private func longitudeFor(location: CLLocation) -> Double {
        return location.coordinate.longitude
    }
    
    /**
     * Checks whether two CLLocations are equal by comparing latitude and longitudes of both coordinates.
     * Used to make sure that a duplicate coordinate is not entered.
     */
    private func equal(loc1: CLLocation, loc2: CLLocation) -> Bool {
        if latitudeFor(loc1) == latitudeFor(loc2) && longitudeFor(loc1) == longitudeFor(loc2) {
            return true
        }
        return false
    }
}
