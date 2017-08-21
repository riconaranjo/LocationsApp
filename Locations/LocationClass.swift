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
    var address:NSString
    /// Contains longitude and latitude values for the location
    var latitude:NSNumber
    var longitude:NSNumber

    
    init() {
        address = "" as NSString
        latitude = 0
        longitude = 0
    }
    
    init(address:NSString, latitude:NSNumber, longitude:NSNumber) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Parses location from CLPlacemark place and stores it in address
    func setAddress(_ place: CLPlacemark) {
        var text = ""
        var locality = place.locality ?? ""
        var thoroughfare = place.thoroughfare ?? ""
        var subThoroughfare = place.subThoroughfare ?? ""
        
        // if all paramters are empty, only add country
        if subThoroughfare == "" && thoroughfare == "" && locality == "" {
            address = place.country as NSString? ?? "No country or address found"
            return
        }
        
        // add space after section if not empty
        if locality         != "" { locality += " " }
        if thoroughfare     != "" { thoroughfare += " " }
        if subThoroughfare  != "" { subThoroughfare += " " }
        
        text = "\(subThoroughfare)\(thoroughfare)\(locality)"
        address = text as NSString
    }
    
    /// Saves coordinates for location
    func setCoordinate(_ location:CLLocation) {
        latitude = location.coordinate.latitude as Double as NSNumber
        longitude = location.coordinate.longitude as Double as NSNumber
    }
}


