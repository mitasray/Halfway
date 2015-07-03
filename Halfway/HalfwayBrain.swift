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
    var current_location: CLLocation! = nil
    var target_location: CLLocation! = nil
    var count: Double = 1
    var targetLocations = [CLLocation]()
    
    public init() {
        self.current_location = CLLocation(latitude: 0, longitude: 0)
        self.target_location = CLLocation(latitude: 0, longitude: 0)
    }
    
    public init(current_location: CLLocation, target_location: CLLocation) {
        self.current_location = current_location
        self.target_location = target_location
    }
    
    public func setCurrentLocation(newLocation: CLLocation) {
        if (self.current_location == CLLocation(latitude: 0, longitude: 0)) {
            self.current_location = newLocation
        }
    }
    
    public func getCurrentLocation() -> CLLocation {
        return self.current_location
    }
    
    /**
     * Returns whether the target location has not already been entered.
     */
    public func setTargetLocation(newLocation: CLLocation) -> Bool {
        for targetLocation in targetLocations {
            // Make sure that this equality doesn't mean that the references are pointed to the same object, but that the values of the lat/long are the same.
            if (newLocation == targetLocation) {
                return false
            }
        }
        self.target_location = newLocation
        self.targetLocations.append(newLocation)
        return true
    }
    
    public func getTargetLocation() -> CLLocation {
        return self.target_location
    }
    
    public func calculateHalfwayLocation() -> CLLocation {
        var latitude = ((latitudeFor(current_location) * count) + latitudeFor(target_location)) / (1 + count)
        var longitude = ((longitudeFor(current_location) * count) + longitudeFor(target_location)) / (1 + count)
        var halfwayLocation = CLLocation(latitude: latitude, longitude: longitude)
        current_location = halfwayLocation
        count += 1
        return halfwayLocation
    }
    
    private func latitudeFor(location: CLLocation) -> Double {
        return location.coordinate.latitude
    }
    
    private func longitudeFor(location: CLLocation) -> Double {
        return location.coordinate.longitude
    }
    
}
