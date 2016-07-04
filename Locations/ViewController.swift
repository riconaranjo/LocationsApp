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
class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addUserLocationButton: UIBarButtonItem!
    @IBOutlet weak var userLocationButton: UIButton!

    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var pressedLocation = CLLocation()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var locationStr = String()
    var firstOpened = Bool() // is the view just being opened
    
    
    // add location where long press
    @IBAction func actionFunction(sender: UILongPressGestureRecognizer) {

        if (sender.state == UIGestureRecognizerState.Ended) {
            print("--- LP: ended ---")
        }
        else if (sender.state == UIGestureRecognizerState.Began) {
            print("--- LP: started ---")
            // gets location of long press relative to map
            let touchPoint = sender.locationInView(mapView)
            
            let newCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
            pressedLocation = CLLocation(latitude: newCoordinate.latitude,longitude: newCoordinate.longitude)
            
            getAddress(false, completionHandler: { (address) in
                if address != nil {
                    self.locationStr = address!
                    
                    // map annotation things
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = self.locationStr
                    annotation.subtitle = "Description"
                    self.mapView.addAnnotation(annotation)
                    self.addLocation()
                }
                else {
                    print("empty location from long press geocoder")
                }
                print("* from actionFuntion: '\(self.locationStr)'")
            })
        }// end long press
    }
    
    // add user's location, from button press
    @IBAction func addUserLocation(sender: UIBarButtonItem) {
            
        getAddress( true, completionHandler: {(address) in
            if address != nil {
                self.locationStr = address!
                print(self.locationStr + "\n---------")
                self.addLocation()
            }
            else {
                print("empty location returned from geocoder")
            }

        })

    }
    
    // get address from location on map
    func getAddress( userLocation:Bool, completionHandler:(address: String?) -> Void) {
        
        if userLocation { // get user's current location
            CLGeocoder().reverseGeocodeLocation(self.userLocation, completionHandler: { (placemarks, error ) -> Void in
                
                if error != nil {
                    print(error)
                }
                else if placemarks?.count > 0 {
                    let place = placemarks![0] as CLPlacemark
                    
                    //print(place.locality)
                    //.ISOcountryCode
                    //.administrativeArea
                    //.sublocality
                    //.throughfare
                    //.subThroughfare // (street number)
                    ///print(place)
                    //print("\(place.subThoroughfare!) \(place.thoroughfare!) \(place.subLocality!)")
                    self.makeLocationString(place.subThoroughfare,thoroughfare: place.thoroughfare,locality: place.locality)
                    completionHandler(address: self.locationStr)
                    
                }
                else {
                    print("error in geocoder")
                    completionHandler(address: nil)
                }
            })
        }
        else { // find location of long press on screen
            
            CLGeocoder().reverseGeocodeLocation(self.pressedLocation, completionHandler: { (placemarks, error ) -> Void in
                
                if error != nil {
                    print(error)
                }
                else if placemarks?.count > 0 {
                    
                    let place = placemarks![0] as CLPlacemark
                    self.makeLocationString(place.subThoroughfare,thoroughfare: place.thoroughfare,locality: place.locality)
                    completionHandler(address: self.locationStr)
                }
                else {
                    print("error in geocoder long press")
                    completionHandler(address: nil)
                }
            })
        }
    }
    
    // add address to list in Location
    func addLocation() {
        
        if locationStr.characters.count > 0 {
            locationList.append(locationStr)
        }
        else {
            print("empty location")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(locationList, forKey:"locationList")
    }
    
    func makeLocationString(subThoroughfare:String?,thoroughfare:String?,locality:String?) {
        
        var notNil = true
        locationStr = "" // clear locationStr
        if subThoroughfare != nil {
            locationStr = subThoroughfare!
            notNil = false
        }
        if thoroughfare != nil {
            locationStr += " \(thoroughfare!)"
            notNil = false
        }
        if locality != nil {
            locationStr += " \(locality!)"
            notNil = false
        }
        if notNil {
            print("nil location")
        }
        else {
            print(locationStr)
        }
        
        
    }
    
    
    // center map on User's location
    @IBAction func mapOnUser(sender: AnyObject) {
        
        let mapSpan = mapView.region.span
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstOpened = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        // long press
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.actionFunction(_:)))
        mapView.addGestureRecognizer(uilpgr)
        uilpgr.minimumPressDuration = 0.5
        
    }

    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        userLocation = locations[0] // the last location
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        /*
        let course = userLocation.course
        let speed = userLocation.speed
        let altitude = userLocation.altitude
        */
        
        // field of view
        if firstOpened {
            let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02,0.02)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
            self.mapView.setRegion(region, animated: false)
            firstOpened = false
        }

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

