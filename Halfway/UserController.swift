//
//  UserController.swift
//  Halfway
//
//  Created by Kevin Arifin on 8/23/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController
import RealmSwift
import MapKit
import CoreLocation

class UserController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        displayUserInformation()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        checkLocationAuthorizationStatus()

    }
    
    func checkLocationAuthorizationStatus() {
        let location = locationManager.location as CLLocation!
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse && location != nil {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func displayUserInformation() {
        usernameLabel.text = logged_in_user().username
        emailLabel.text = logged_in_user().email
        numberOfFriendsLabel.text = String(logged_in_user().friends.count)
    }
    
    private func logged_in_user() -> User {
        let realm = try! Realm()
        return realm.objects(User).first!
    }
}
