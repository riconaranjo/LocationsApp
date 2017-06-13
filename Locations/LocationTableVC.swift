//
//  LocationTableViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit
import MapKit

var row = -1    // this value is used for segueing to map location from row, else -1

// Table View with locations
class LocationTableVC: UITableViewController {

    var locationsTable:[Location] = []
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var locationTableView: UITableView!
    @IBOutlet weak var testButton: UIBarButtonItem!
    
    // Clear All button
    @IBAction func ClearButtonTapped(_ sender: AnyObject) {
        
        locationList.removeAll()
        latitudeList.removeAll()
        longitudeList.removeAll()
        
        tableView.reloadData()
        
        // save list in local storage
        saveLocations(CLLocation())
    }
    
    // when view loads, 'do this'
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        
        locationsTable = UserDefaults.standard.object(forKey: "locationsTable") as? [Location] ?? locationsTable
        print(locationsTable[1])
        
        // if location
        if UserDefaults.standard.object(forKey: "locationList") != nil {
            locationList = UserDefaults.standard.object(forKey: "locationList") as! [String]
        }
        else {
            print("locationList is empty" )
        }
        if UserDefaults.standard.object(forKey: "latitudeList") != nil {
            latitudeList = UserDefaults.standard.object(forKey: "latitudeList") as! [Double]
        }
        else {
            print("latitudeList is empty" )
        }
        if UserDefaults.standard.object(forKey: "longitudeList") != nil {
            longitudeList = UserDefaults.standard.object(forKey: "longitudeList") as![Double]
        }
        else {
            print("latitudeList is empty" )
        }
        
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Preferred status bar style lightContent to use on dark background.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Reload table with any new data
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // segue to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        //let vc = segue.destination as! MapVC
        
        if segue.identifier == "locationTable" {
            // send specific coordinates
            
        }
        else if segue.identifier == "addButton" {
            // centre map on user
            row = -1
        }
    }
    
    /// Return the number of sections in table sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /// returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }

    /// populates rows with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        cell.textLabel?.text = locationList[(indexPath as NSIndexPath).row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.37, alpha:1.0)
        return cell
    }
    
    /// Enables swipe left to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // if swipe to left to delete:
        if editingStyle == UITableViewCellEditingStyle.delete {
            locationList.remove(at: (indexPath as NSIndexPath).row)
            latitudeList.remove(at: (indexPath as NSIndexPath).row)
            longitudeList.remove(at: (indexPath as NSIndexPath).row)
        }
        
        // update table and stored data
        tableView.reloadData()
        saveLocations(CLLocation())
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = (indexPath as NSIndexPath).row
    }
    
    /// Changes app theme
    func applyTheme() {
        // todo: finish adding colour scheme
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = Style.COLOUR_1
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Style.COLOUR_5]
        self.tableView.backgroundColor = Style.COLOUR_2
        self.tableView.isOpaque = false
        
        // this changes status bar to white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        
    }
}

/// Saves location names and coordinates in local data (UserDefaults)
func saveLocations(_ x:CLLocation) {
    UserDefaults.standard.set(locationList, forKey: "locationList")
    UserDefaults.standard.set(latitudeList, forKey: "latitudeList")
    UserDefaults.standard.set(longitudeList, forKey: "longitudeList")
    UserDefaults.standard.set(x, forKey: "locationsTable")
}



