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
        self.current_location = newLocation
    }
    
    public func getCurrentLocation() -> CLLocation {
        return self.current_location
    }
    
    public func setTargetLocation(newLocation: CLLocation) -> Bool {
        for targetLocation in targetLocations {
            if (equal(targetLocation, loc2: newLocation)) {
                return false
            }
        }
        targetLocations.append(newLocation)
        self.target_location = newLocation
        return true
    }
    
    public func getTargetLocation() -> CLLocation {
        return self.targetLocations[targetLocations.count - 1]
    }
    
    public func calculateHalfwayLocation() -> CLLocation {
        var totLat = latitudeFor(current_location)
        var totLong = longitudeFor(current_location)
        var count: Double = 1
        for loc in targetLocations {
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
        if ((latitudeFor(loc1) == latitudeFor(loc2)) && (longitudeFor(loc1) == longitudeFor(loc2))) {
            return true
        }
        return false
    }
    
    public func getMapCoordinates(yelpLocation: CLLocation) -> [Double] {
        var maxLat = latitudeFor(current_location)
        var minLat = latitudeFor(current_location)
        var maxLong = longitudeFor(current_location)
        var minLong = longitudeFor(current_location)
        
        // Appending yelpLocation to be used for map coordinates calculations.
        targetLocations.append(yelpLocation)
        for loc in targetLocations {
            var locLat = latitudeFor(loc)
            var locLong = longitudeFor(loc)
            
            if (maxLat < locLat) {
                maxLat = locLat
            }
            if (minLat > locLat) {
                minLat = locLat
            }
            if (maxLong < locLong) {
                maxLong = locLong
            }
            if (minLong > locLong) {
                minLong = locLong
            }
        }
        targetLocations.removeLast()
        
        var centerLat = (maxLat + minLat) / 2
        var centerLong = (maxLong + minLong) / 2
        
        var latDistance: Double = CLLocation(latitude: maxLat, longitude: maxLong).distanceFromLocation(CLLocation(latitude: minLat, longitude: maxLong))
        var longDistance: Double = CLLocation(latitude: maxLat, longitude: maxLong).distanceFromLocation(CLLocation(latitude: maxLat, longitude: minLong))
        
        // This check indicates whether the yelpLocation is the maxLat. If so, we readjust centerLat and latDistance to ensure viewing of the label.
        if (latitudeFor(yelpLocation) == maxLat || latitudeFor(yelpLocation) == minLat) {
            var latSeparation = (maxLat - centerLat) * 0.5
            // var longSeparation = (maxLong - centerLong) * 0.5
            centerLat += latSeparation
            // centerLong += longSeparation
            latDistance += latSeparation * 2.5
            // longDistance += longSeparation * 2
        }
        
        return [centerLat, centerLong, latDistance, longDistance]
    }
}
