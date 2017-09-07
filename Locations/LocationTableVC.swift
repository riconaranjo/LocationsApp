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

    var locationTable:[Location] = []
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var locationTableView: UITableView!
    @IBOutlet weak var testButton: UIBarButtonItem!
    
    // Clear All button
    @IBAction func ClearButtonTapped(_ sender: AnyObject) {
        
        locationTable.removeAll()
        clearLocationTable()
        tableView.reloadData()
        
        // save list in local storage
        clearLocationTable()
    }
    
    // when view loads, 'initial set-up'
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()

        tableView.reloadData()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Preferred status bar style lightContent to use on dark background.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Reload table with any new data everytime table will appear
    override func viewWillAppear(_ animated: Bool) {
        let tempAddress = UserDefaults.standard.object(forKey: "tempAddress") as? [NSString] ?? [NSString]()
        let tempLat = UserDefaults.standard.object(forKey: "tempLat") as? [NSNumber] ?? [NSNumber]()
        let tempLong = UserDefaults.standard.object(forKey: "tempLong") as? [NSNumber] ?? [NSNumber]()
        
        // if one of the lists is empty, quit
        if tempAddress.count == 0 || tempLat.count == 0 || tempLong.count == 0 {
            return
        } // if one of the lists is different
        if tempAddress.count != tempLat.count || tempAddress.count != tempLong.count {
            print("One of the lists was not the same size")
            return
        }
        
        buildLocationTable(tempAddresses: tempAddress, tempLat: tempLat, tempLong: tempLong)
        tableView.reloadData()
    }

    // Segue to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        let mapVC = segue.destination as! MapVC
        mapVC.tableVC = self
        
        if segue.identifier == "rowSelected" {
            // send specific coordinates
            if let indexPath = self.tableView.indexPathForSelectedRow {
                mapVC.sentLocation = locationTable[(indexPath as NSIndexPath).row]
            }
        }
        else if segue.identifier == "addButton" {
            // centre map on user
            let emptyLocation = Location()
            emptyLocation.address = "empty"
            mapVC.sentLocation = emptyLocation
        }
        // send all locations for map pins
        mapVC.locationTable = locationTable
    }
    
    /// Return the number of sections in table sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /// Returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationTable.count
    }

    /// Populates rows with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        let location = locationTable[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = location.address as String
        
        cell.textLabel?.textColor = UIColor.white
        
        // todo: this is in constants folder?!
        cell.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.37, alpha:1.0)
        return cell
    }
    
    /// Enables swipe left to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // if swipe to left to delete:
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            locationTable.remove(at: (indexPath as NSIndexPath).row)
            deleteAtIndexLocationTable(at: (indexPath as NSIndexPath).row)
        }
        
        // update table and stored data
        tableView.reloadData()
    }
    
    /// Action when cell in tableview is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    /// takes data saved in NSUserDefaults, and popluates the table
    func buildLocationTable(tempAddresses:[NSString], tempLat:[NSNumber], tempLong:[NSNumber]) {
        
        let size = [tempAddresses.count, tempLat.count, tempLong.count].min() ?? 0
        
        if size == 0 { return } // if empty 
        
        locationTable.removeAll()   // clear array since not checking if location exists in list
        
        for index in 0..<size {
            let location = Location(address: tempAddresses[index], latitude: tempLat[index], longitude: tempLong[index])
            locationTable.append(location)
        }
    }
}

/// Clears the locationTable in local data (UserDefaults)
func clearLocationTable() {
    let tempAddress = [NSString]()
    let tempLat = [NSNumber]()
    let tempLong = [NSNumber]()
    
    UserDefaults.standard.set(tempAddress, forKey: "tempAddress")
    UserDefaults.standard.set(tempLat, forKey: "tempLat")
    UserDefaults.standard.set(tempLong, forKey: "tempLong")
}

/// Clears the locationTable in local data (UserDefaults)
func deleteAtIndexLocationTable(at:Int) {
    var tempAddress = UserDefaults.standard.object(forKey: "tempAddress") as? [NSString] ?? [NSString]()
    var tempLat = UserDefaults.standard.object(forKey: "tempLat") as? [NSNumber] ?? [NSNumber]()
    var tempLong = UserDefaults.standard.object(forKey: "tempLong") as? [NSNumber] ?? [NSNumber]()
    
    if tempAddress.count == 0 { return }
    
    tempAddress.remove(at: at)
    tempLat.remove(at: at)
    tempLong.remove(at: at)
    
    UserDefaults.standard.set(tempAddress, forKey: "tempAddress")
    UserDefaults.standard.set(tempLat, forKey: "tempLat")
    UserDefaults.standard.set(tempLong, forKey: "tempLong")
}
