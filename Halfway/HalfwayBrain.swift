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
    var current_location: CLLocation
    var target_location: CLLocation
    
    public init() {
        self.current_location = CLLocation(latitude: 0, longitude: 0)
        self.target_location = CLLocation(latitude: 0, longitude: 0)
    }
    
    public init(current_location: CLLocation, target_location: CLLocation) {
        self.current_location = current_location
        self.target_location = target_location
    }
    
    public func setCurrentLocation(newLocation: CLLocation) {
        self.current_location = newLocation
    }
    
    public func getCurrentLocation() -> CLLocation {
        return self.current_location
    }
    
    public func setTargetLocation(newLocation: CLLocation) {
        self.target_location = newLocation
    }
    
    public func getTargetLocation() -> CLLocation {
        return self.target_location
    }
    
    public func calculateHalfwayLocation() -> CLLocation {
        var latitude = (latitudeFor(current_location) + latitudeFor(target_location)) / 2
        var longitude = (longitudeFor(current_location) + longitudeFor(target_location)) / 2
        var halfwayLocation = CLLocation(latitude: latitude, longitude: longitude)
        return halfwayLocation
    }
    
    private func latitudeFor(location: CLLocation) -> Double {
        return location.coordinate.latitude
    }
    
    private func longitudeFor(location: CLLocation) -> Double {
        return location.coordinate.longitude
    }
}
