//
//  LocationTableViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit

/* Notes:
 * - implement dictionary instead of 3 arrays
 */

//var locationDictionary = [String:[Double]]()

var locationList = [String]() // holds address
var latitudeList = [Double]()
var longitudeList = [Double]()
// all arrays map one-to-one for each location
var row = -1    // this value is used for segueing to map location from row, else -1


// Table View with locations
class LocationTableVC: UITableViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var locationTableView: UITableView!
    
    @IBOutlet weak var testButton: UIBarButtonItem!
    
    
    // testing function right now, clears table, might make into proper Clear All button 
    @IBAction func testRow(_ sender: AnyObject) {
        
        locationList.removeAll()
        latitudeList.removeAll()
        longitudeList.removeAll()
        
        tableView.reloadData()
        
        // save list in local storage
        saveLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // segue to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        if segue.identifier == "locationTable" {
        }
        else if segue.identifier == "addButton"{
            row = -1
        }
    }
    
    // Reload table with any new data
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    /// @brief Retrn the number of sections in table sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        cell.textLabel?.text = locationList[(indexPath as NSIndexPath).row]

        return cell
    }
    
    
    /// @brief Enables swipe left to delete row functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // if swipe to left to delete:
        if editingStyle == UITableViewCellEditingStyle.delete {
            locationList.remove(at: (indexPath as NSIndexPath).row)
            latitudeList.remove(at: (indexPath as NSIndexPath).row)
            longitudeList.remove(at: (indexPath as NSIndexPath).row)
        }
        
        // update table and stored data
        tableView.reloadData()
        saveLocations()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = (indexPath as NSIndexPath).row
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/// @brief Saves location names and coordinates in local data (UserDefaults)
func saveLocations() {
    UserDefaults.standard.set(locationList, forKey: "locationList")
    UserDefaults.standard.set(latitudeList, forKey: "latitudeList")
    UserDefaults.standard.set(longitudeList, forKey: "longitudeList")
}