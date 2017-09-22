//
//  ViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// Map View
class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addUserLocationButton: UIBarButtonItem!
    @IBOutlet weak var userLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var locations = [Location]()
    var firstOpened = Bool() // is the view just being opened
    var rowSegue:Bool = false
    var rowLocation:Location?
    var tableVC:LocationTableVC?
    
    /// add location where long press
    @IBAction func addLongPressLocation(_ sender: UILongPressGestureRecognizer) {
        
        // gets location of long press relative to map
        if (sender.state == UIGestureRecognizerState.began) {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let pressed = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            _ = addLocation(pressed, isUser: false)
        }
    }
    
    /// Store the user's location when button tapped
    @IBAction func addUserLocation(_ sender: UIBarButtonItem) {
        _ = addLocation(userLocation, isUser: true)
    }
    
    /// centres the map on User's location
    @IBAction func mapOnUser(_ sender: AnyObject) {
        let mapSpan = mapView.region.span
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
        self.mapView.setRegion(region, animated: true)
    }
    
    /// Automatically updates the GPS location of user and where map is centred.
    /// This function is called by the system
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        userLocation = locations[0]     // the last location
        
        // field of view
        if firstOpened {
            let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02,0.02)
            var region = MKCoordinateRegion()
            
            // if not coming from row press, centre on user
            if rowSegue {
                let location = self.rowLocation
                let lat = location?.latitude
                let long = location?.longitude
                let coordinate = CLLocationCoordinate2DMake(lat!, long!)
                region = MKCoordinateRegionMake(coordinate,mapSpan)
            }
            // else focus on location in row
            else {
                region = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
            }
            
            self.mapView.setRegion(region, animated: false)
            
            // todo: remove?
            firstOpened = false // stop forcing map centred on user
        }
    }
    
    /// takes the CLLocation, and finds the placemark from reverse geocoder
    func getPlacemark(_ cllocation:CLLocation, location:Location, isUser:Bool) {
        CLGeocoder().reverseGeocodeLocation(cllocation, completionHandler: { (placemarks, error ) in
            
            if error != nil || placemarks == nil || placemarks!.count == 0 {
                print(error ?? "Unknown error in geocoder")
                return
            }
            
            let place = placemarks![0] as CLPlacemark
            
            location.address = self.parseAddress(place)
            location.latitude = cllocation.coordinate.latitude
            location.longitude = cllocation.coordinate.longitude
            
            // if location is close enough to existing location, do not add it
            for each in self.locations {
                let x = location.latitude
                let y = each.latitude
                let latResult = fabs(x - y) < 0.0002
                
                let u = location.longitude
                let v = each.longitude
                let longResult = fabs(u - v) < 0.0002
                
                if latResult && longResult {
                    let context = getContext()
                    context.delete(location)
                    return
                }
            }
            
            saveContext()
            
            // if adding user location, segue back to table view
            if(isUser) {
                self.tableVC?.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
            
            // map annotation things
            let annotation = MKPointAnnotation()
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = location.address
            // todo: add ability for user to add/modify description later
            //annotation.subtitle = "Description"
            self.mapView.addAnnotation(annotation)
        })
    }
    
    /// Parses location from CLPlacemark place and stores it in address
    func parseAddress(_ place: CLPlacemark) -> String {
        var address = ""
        var locality = place.locality ?? ""
        var thoroughfare = place.thoroughfare ?? ""
        var subThoroughfare = place.subThoroughfare ?? ""
        
        // if all paramters are empty, only add country
        if subThoroughfare == "" && thoroughfare == "" && locality == "" {
            address = place.country ?? "No country or address found"
            return address
        }
        
        // add space after section if not empty
        if locality         != "" { locality += " " }
        if thoroughfare     != "" { thoroughfare += " " }
        if subThoroughfare  != "" { subThoroughfare += " " }
        
        address = "\(subThoroughfare)\(thoroughfare)\(locality)"
        return address
    }

    
    /// Adds and saves location names and coordinates in local data (UserDefaults)
    func addLocation(_ cllocation:CLLocation, isUser:Bool = false) -> Location {
        let location = Location(context: getContext())
        getPlacemark(cllocation, location: location, isUser: isUser)
        return location
    }
    
    /// Fetches locations in CoreData and stores them in locations array
    func getLocations() {
        // set up the context for core data
        let context = getContext()
        
        do {
            locations = try context.fetch(Location.fetchRequest()) as! [Location]
        }
        catch {
            print("fetch error in Map View")
        }
    }
    
    /// Add Map Pins in locations array
    func addMapPins() {
        for location in locations {
            let annotation = MKPointAnnotation()
            let address = location.address
            let lat = location.latitude
            let long = location.longitude
            
            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            annotation.title = address
            
            // todo: add description capabilties
            //annotation.subtitle = "Description"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets up the delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        getLocations()
        addMapPins()
        
        // show user as blue dot
        mapView.showsUserLocation = true
        
        // allow long press to add map pin
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.addLongPressLocation(_:)))
        mapView.addGestureRecognizer(uilpgr)
        uilpgr.minimumPressDuration = 0.35
        
        // if the view just being opened -> centre the map on user location
        firstOpened = true
    }
}
