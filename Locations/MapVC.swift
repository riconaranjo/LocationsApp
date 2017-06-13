//
//  ViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit
import MapKit

// Map View
class MapVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addUserLocationButton: UIBarButtonItem!
    @IBOutlet weak var userLocationButton: UIButton!
        
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var locationStr = String()
    
    var firstOpened = Bool() // is the view just being opened
    
    // add location where long press
    @IBAction func addLongPressLocation(_ sender: UILongPressGestureRecognizer) {
        
        // gets location of long press relative to map
        if (sender.state == UIGestureRecognizerState.began) {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let pressed = CLLocation(
                latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            let location = Location(pressed)
            
            // map annotation things
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = self.locationStr
            // todo: add ability for user to add/modify description later
            //annotation.subtitle = "Description"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // Store the user's location when button tapped
    @IBAction func addUserLocation(_ sender: UIBarButtonItem) {
        _ = Location(userLocation)
    }
    
    /// centres the map on User's location
    @IBAction func mapOnUser(_ sender: AnyObject) {
        let mapSpan = mapView.region.span
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
        self.mapView.setRegion(region, animated: true)
    }
    
    /// automatically updates location of user
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        userLocation = locations[0]     // the last location
        
        // field of view
        if firstOpened {
            let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02,0.02)
            var region = MKCoordinateRegion()
            
            // todo: update
            if row == -1  {     // if not coming from row press
                region = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
            }
            else {      // else focus on location in row
                let lat = latitudeList[row] as CLLocationDegrees
                let long = longitudeList[row] as CLLocationDegrees
                let coordinate = CLLocationCoordinate2DMake(lat, long)
                region = MKCoordinateRegionMake(coordinate,mapSpan)
            }
            
            self.mapView.setRegion(region, animated: false)
            firstOpened = false // stop forcing map centred on user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets up the delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // centre image on user
        
        // update arrays and check if any are empty
        if UserDefaults.standard.object(forKey: "locationTable") != nil {
            locationList = UserDefaults.standard.object(forKey: "locationTable") as! [String]

            // like a foreach with index too
            for(index,element) in locationList.enumerated() {
                
                let annotation = MKPointAnnotation()
                let locStr = element
                let lat = latitudeList[index] as CLLocationDegrees
                let long = longitudeList[index] as CLLocationDegrees
                
                annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                annotation.title = locStr
                // todo: add description capabilties
                //annotation.subtitle = "Description"
                self.mapView.addAnnotation(annotation)
            }
        }
        
        // show user as blue dot
        mapView.showsUserLocation = true
        
        // add long press functionality to map view
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.addLongPressLocation(_:)))
        mapView.addGestureRecognizer(uilpgr)
        uilpgr.minimumPressDuration = 0.35
        
        firstOpened = true // if the view just being opened -> centre the map on user location
    }
}
