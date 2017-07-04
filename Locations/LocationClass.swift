//
//  Location.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 6/6/17.
//  Copyright © 2017 Rico. All rights reserved.
//

import UIKit
import MapKit

class Location {
    
    /// Holds the address for the location in format:
    /// \(place.subThoroughfare!) \(place.thoroughfare!) \(place.locality!)
    var address:String
    /// Contains longitude and latitude values for the location
    var coordinate:CLLocationCoordinate2D
    
    var nsAddress:NSString
    var nsLat:NSNumber
    var nsLong:NSNumber

    
    init() {
        address = ""
        coordinate = CLLocationCoordinate2D()
        
        nsAddress = address as NSString
        nsLat = coordinate.latitude as Double as NSNumber
        nsLong = coordinate.longitude as Double as NSNumber
    }
    
    init(address:NSString, latitude:NSNumber, longitude:NSNumber) {
        self.address = address as String
        
        let lat = latitude as! CLLocationDegrees
        let long = longitude as! CLLocationDegrees
        coordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
        
        nsAddress = address as NSString
        nsLat = coordinate.latitude as NSNumber
        nsLong = coordinate.longitude as NSNumber
    }
    
    /// Parses location from CLPlacemark place and stores it in address
    func setAddress(_ place: CLPlacemark) {

        var text = ""
        var locality = place.locality ?? ""
        var thoroughfare = place.thoroughfare ?? ""
        var subThoroughfare = place.subThoroughfare ?? ""
        
        // if all paramters are empty, only add country
        if subThoroughfare == "" && thoroughfare == "" && locality == "" {
            address = place.country ?? "No country or address found"
            return
        }
        
        // add space after section if not empty
        if locality         != "" { locality += " " }
        if thoroughfare     != "" { thoroughfare += " " }
        if subThoroughfare  != "" { subThoroughfare += " " }
        
        text = "\(subThoroughfare)\(thoroughfare)\(locality)"
        address = text
        nsAddress = address as NSString
    }
    
    /// Saves coordinates for location
    func setCoordinate(_ location:CLLocation) {
        coordinate = location.coordinate
        nsLat = coordinate.latitude as Double as NSNumber
        nsLong = coordinate.longitude as Double as NSNumber

    }
}


