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
    
    /// takes the CLLocation, parses the address, and saves coordinates
    init(_ location:CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error ) -> Void in
            
            if error != nil {
                print(error!)
            }
            else if placemarks != nil && placemarks!.count > 0 {
                let place = placemarks![0] as CLPlacemark
                
                self.setAddress(place)
            }
            else {
                print("error in geocoder")
            }
        })
        
        setCoordinates(location)
    }
    
    /// Parses location from CLPlacemark place and stores it in address
    private func setAddress(_ place: CLPlacemark) {

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
    }
    
    /// Saves coordinates for location
    private func setCoordinates(_ location:CLLocation) {
        coordinate = location.coordinate
    }
}


