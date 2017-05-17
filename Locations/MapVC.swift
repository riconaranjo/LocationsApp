//
//  ViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit
import MapKit
//import LocationTableVC


// Map View
class MapVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addUserLocationButton: UIBarButtonItem!
    @IBOutlet weak var userLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var pressedLocation = CLLocation()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var locationStr = String()
    
    var firstOpened = Bool() // is the view just being opened
    
    // add location where long press
    @IBAction func addLongPressLocation(_ sender: UILongPressGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.ended) {
        }
        else if (sender.state == UIGestureRecognizerState.began) {
            // gets location of long press relative to map
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            pressedLocation = CLLocation(
                latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            getAddress(false, closure: { (address) in
                
                if address != nil {
                    
                    self.locationStr = address!
                    
                    // map annotation things
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = self.locationStr
                    // todo: add ability for user to add/modify description later
                    //annotation.subtitle = "Description"
                    self.mapView.addAnnotation(annotation)
                    self.latitude = annotation.coordinate.latitude
                    self.longitude = annotation.coordinate.longitude
                    self.addLocation()
                }
                else {
                    print("empty location from long press geocoder")
                }
            })
        } // end long press
    }
    
    // add user's location, from button press
    @IBAction func addUserLocation(_ sender: UIBarButtonItem) {
        
        getAddress( true, closure: { (address) in
            if address != nil && address != "" {
                self.locationStr = address!
                self.addLocation()
            }
            else {
                print("empty location returned from geocoder")
            }
        })
    }
    
    /// @brief gets coordinates of location from geocoder
    func getAddress(_ isUserLocation:Bool, closure:@escaping (_ address:String?) -> Void) {
        
        var location = CLLocation()
        isUserLocation == true ? (location = userLocation) : (location = pressedLocation)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error ) -> Void in
            
            if error != nil {
                print(error!)
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
                self.makeLocationString(place.subThoroughfare, thoroughfare: place.thoroughfare, locality: place.locality)
                closure(self.locationStr)
            }
            else {
                print("error in geocoder")
                closure(nil)
            }
            
        })
    }

    /// @brief adds location in locationStr, latitude, and  longitude
    func addLocation() {
        
        if locationStr.characters.count > 0 {
            locationList.append(locationStr)
            latitudeList.append(latitude)
            longitudeList.append(longitude)
        }
        else {
            print("empty location")
        }
        
        // save arrays
        saveLocations()
    }
    
    // loads address into locationStr as string
    func makeLocationString(_ subThoroughfare:String?, thoroughfare:String?, locality:String?) {
        
        var notNil = true
        var firstString = true
        locationStr = ""        // clears locationStr
        
        if subThoroughfare != nil {
            
            locationStr = subThoroughfare!
            notNil = false
            firstString = false
        }
        
        if thoroughfare != nil {
            
            if firstString {
                locationStr += "\(thoroughfare!)"
                firstString = false
            }
            else {
                locationStr += " \(thoroughfare!)"
            }
            notNil = false
        }
        
        if locality != nil {
            
            if firstString {
                locationStr += "\(locality!)"
            }
            else {
                locationStr += " \(locality!)"
            }
            notNil = false
        }
        
        if notNil {
            print("nil location")
        }
    }
    
    // centre map on User's location
    @IBAction func mapOnUser(_ sender: AnyObject) {
        let mapSpan = mapView.region.span
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
        self.mapView.setRegion(region, animated: true)
    }
    
    // updates location of user
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        userLocation = locations[0]     // the last location
        latitude  = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
        // field of view
        if firstOpened {
            let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02,0.02)
            var region = MKCoordinateRegion()
            
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
        
        // flags for updateing map pins
        var locationListEmpty = true
        var latitudeListEmpty = true
        var longitudeListEmpty = true
        
        // center image on user
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // update arrays and check if any are empty
        if UserDefaults.standard.object(forKey: "locationList") != nil {
            locationList = UserDefaults.standard.object(forKey: "locationList") as! [String]
            locationListEmpty = false
        }
        
        if UserDefaults.standard.object(forKey: "latitudeList") != nil {
            latitudeList = UserDefaults.standard.object(forKey: "latitudeList") as! [Double]
            latitudeListEmpty = false
        }
        
        if UserDefaults.standard.object(forKey: "longitudeList") != nil {
            longitudeList = UserDefaults.standard.object(forKey: "longitudeList") as![Double]
            longitudeListEmpty = false
        }
        
        // if locations have been saved, show them on map as pins
        if !locationListEmpty && !latitudeListEmpty && !longitudeListEmpty {
            
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
        
        firstOpened = true // if the view just being opened -> centre on user location
    }
}


/// @brief pattern recognition for comparing (long, lat) positons
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
        
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
        
    default:
        return rhs < lhs
    }
}
