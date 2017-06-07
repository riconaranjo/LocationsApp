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
    var address = ""
    /// Contains longitude and latitude values for the location
    var coordinate = CLLocationCoordinate2D()
    
    /// Parses location from CLPlacemark place and stores it in address
    func setAddress(_ place: CLPlacemark) {

        var text = ""
        let locality = place.locality ?? ""
        let thoroughfare = place.thoroughfare ?? ""
        let subThoroughfare = place.subThoroughfare ?? ""
        
        // if all paramters are empty, quit
        if subThoroughfare == "" && thoroughfare == "" && locality == "" {
            return
        }
        
        text = "\(subThoroughfare) \(thoroughfare) \(locality)"
        address = text
    }
}
