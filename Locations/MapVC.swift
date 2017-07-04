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
class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addUserLocationButton: UIBarButtonItem!
    @IBOutlet weak var userLocationButton: UIButton!
        
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var locationTable = [Location]()
    var sentLocation = Location()
    var firstOpened = Bool() // is the view just being opened
    
    /// add location where long press
    @IBAction func addLongPressLocation(_ sender: UILongPressGestureRecognizer) {
        
        // gets location of long press relative to map
        if (sender.state == UIGestureRecognizerState.began) {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let pressed = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            //let location = addLocation(pressed)
            _ = addLocation(pressed)
        }
    }
    
    /// Store the user's location when button tapped
    @IBAction func addUserLocation(_ sender: UIBarButtonItem) {
        _ = addLocation(userLocation)
    }
    
    /// centres the map on User's location
    @IBAction func mapOnUser(_ sender: AnyObject) {
        let mapSpan = mapView.region.span
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
        self.mapView.setRegion(region, animated: true)
    }
    
    /// automatically updates location of user + where map is centred
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        userLocation = locations[0]     // the last location
        
        // field of view
        if firstOpened {
            let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02,0.02)
            var region = MKCoordinateRegion()
            
            // if not coming from row press
            if sentLocation.address == "empty" {
                region = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
            }
            // else focus on location in row
            else {
                let lat = sentLocation.coordinate.latitude as CLLocationDegrees
                let long = sentLocation.coordinate.longitude as CLLocationDegrees
                let coordinate = CLLocationCoordinate2DMake(lat, long)
                region = MKCoordinateRegionMake(coordinate,mapSpan)
            }
            
            self.mapView.setRegion(region, animated: false)
            firstOpened = false // stop forcing map centred on user
        }
    }
    
    /// takes the CLLocation, and finds the placemark from reverse geocoder
    func getPlacemark(_ cllocation:CLLocation, location: Location) {
        CLGeocoder().reverseGeocodeLocation(cllocation, completionHandler: { (placemarks, error ) in
            
            if error != nil || placemarks == nil || placemarks!.count == 0 {
                print(error ?? "Unknown error in geocoder")
                return
            }
            
            let p = placemarks![0] as CLPlacemark
            location.setAddress(p)
            location.setCoordinate(cllocation)
            
            var tempAddress = UserDefaults.standard.object(forKey: "tempAddress") as? [NSString] ?? [NSString]()
            var tempLat = UserDefaults.standard.object(forKey: "tempLat") as? [NSNumber] ?? [NSNumber]()
            var tempLong = UserDefaults.standard.object(forKey: "tempLong") as? [NSNumber] ?? [NSNumber]()
            
            
            for(index, lat) in tempLat.enumerated() {
                let x = lat as! Double
                let y = location.nsLat as! Double
                let latResult = fabs(x - y) < 0.0002
                
                let u = tempLong[index] as! Double
                let v = location.nsLong as! Double
                let longResult = fabs(u - v) < 0.0002
                
                if latResult && longResult {
                    return
                }
            }
            
            tempAddress.append(location.nsAddress)
            tempLat.append(location.nsLat)
            tempLong.append(location.nsLong)
            
            UserDefaults.standard.set(tempAddress, forKey: "tempAddress")
            UserDefaults.standard.set(tempLat, forKey: "tempLat")
            UserDefaults.standard.set(tempLong, forKey: "tempLong")
            
            // map annotation things
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.address
            // todo: add ability for user to add/modify description later
            //annotation.subtitle = "Description"
            self.mapView.addAnnotation(annotation)
        })
    }
    
    /// Adds and saves location names and coordinates in local data (UserDefaults)
    func addLocation(_ cllocation:CLLocation) -> Location {
        let location = Location()
        getPlacemark(cllocation, location: location)
        return location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets up the delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // centre image on user or saved location + add map pins
        if locationTable.count != 0 {
            
            // like a foreach (with index, but not used)
            for(_,loc) in locationTable.enumerated() {
                
                let annotation = MKPointAnnotation()
                let address = loc.address
                let lat = loc.coordinate.latitude as CLLocationDegrees
                let long = loc.coordinate.longitude as CLLocationDegrees
                
                annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                annotation.title = address
                
                // todo: add description capabilties
                //annotation.subtitle = "Description"
                self.mapView.addAnnotation(annotation)
            }
        }
        
        // show user as blue dot
        mapView.showsUserLocation = true
        
        // allow long press to add map pin
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.addLongPressLocation(_:)))
        mapView.addGestureRecognizer(uilpgr)
        uilpgr.minimumPressDuration = 0.35
        
        firstOpened = true // if the view just being opened -> centre the map on user location
    }
}
