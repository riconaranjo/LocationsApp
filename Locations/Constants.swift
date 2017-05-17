//
//  Constants.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 16/5/17.
//  Copyright © 2017 Rico. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    
    static let availableThemes = ["Theme 1","Theme 2","Theme 3"]
    static var COLOUR_1 = UIColor(red:0.13, green:0.11, blue:0.14, alpha:1.0)   // #221C23
    static var COLOUR_2 = UIColor(red:0.23, green:0.23, blue:0.28, alpha:1.0)   // #3A3A47
    static var COLOUR_3 = UIColor(red:0.36, green:0.42, blue:0.42, alpha:1.0)   // #5D6A6B
    static var COLOUR_4 = UIColor(red:0.50, green:0.69, blue:0.57, alpha:1.0)   // #80B192
    static var COLOUR_5 = UIColor(red:0.60, green:0.76, blue:0.55, alpha:1.0)   // #99C18D
    
    static func loadTheme() {
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "Theme") {
            
            // Select theme
            if name == availableThemes[0] { theme1() }
            if name == availableThemes[1] { theme2() }
            if name == availableThemes[2] { theme3() }
        }
        else {
            defaults.set(availableThemes[0], forKey: "Theme")
            theme1()
        }
    }
    
    // Colours specific to theme - can include multiple colours here for each one
    static func theme1() {
        COLOUR_1 = UIColor(red:0.13, green:0.11, blue:0.14, alpha:1.0)   // #221C23
        COLOUR_2 = UIColor(red:0.23, green:0.23, blue:0.28, alpha:1.0)   // #3A3A47
        COLOUR_3 = UIColor(red:0.36, green:0.42, blue:0.42, alpha:1.0)   // #5D6A6B
        COLOUR_4 = UIColor(red:0.50, green:0.69, blue:0.57, alpha:1.0)   // #80B192
        COLOUR_5 = UIColor(red:0.60, green:0.76, blue:0.55, alpha:1.0)   // #99C18D
    }
    
    static func theme2() {
        COLOUR_1 = UIColor(red:0.29, green:0.21, blue:0.28, alpha:1.0)   // #493548
        COLOUR_2 = UIColor(red:0.29, green:0.31, blue:0.43, alpha:1.0)   // #4B4E6D
        COLOUR_3 = UIColor(red:0.42, green:0.55, blue:0.57, alpha:1.0)   // #6A8D92
        COLOUR_4 = UIColor(red:0.50, green:0.69, blue:0.57, alpha:1.0)   // #80B192
        COLOUR_5 = UIColor(red:0.63, green:0.91, blue:0.53, alpha:1.0)   // #A1E887
    }
    
    static func theme3() {
        COLOUR_1 = UIColor(red:0.29, green:0.21, blue:0.28, alpha:1.0)   // #493548
        COLOUR_2 = UIColor(red:0.29, green:0.31, blue:0.43, alpha:1.0)   // #4B4E6D
        COLOUR_3 = UIColor(red:0.42, green:0.55, blue:0.57, alpha:1.0)   // #6A8D92
        COLOUR_4 = UIColor(red:0.50, green:0.69, blue:0.57, alpha:1.0)   // #80B192
        COLOUR_5 = UIColor(red:0.63, green:0.91, blue:0.53, alpha:1.0)   // #A1E887
    }
}







