//
//  LocationTableViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit

/* Notes:
 * - implement so when location in list is pressed the location is shown centered on map
 * - implement dictionary instead of 3 arrays
 */

//var locationDictionary = [String:[Double]]()

var locationList = [String]() // holds address
var latitudeList = [Double]()
var longitudeList = [Double]()
// all arrays map one-to-one for each location
var row = -1
// row selected on table view, -1 for non or add button pressed for segue


/*--------------------------------------------------------------------------*/

// Table View with locations
class LocationTableViewController: UITableViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var locationTableView: UITableView!
    
    @IBOutlet weak var testButton: UIBarButtonItem!
    
    
    // testing function right now, clears table, might make into proper Clear All button 
    @IBAction func testRow(sender: AnyObject) {
        
        locationList.removeAll()
        latitudeList.removeAll()
        longitudeList.removeAll()
        
        tableView.reloadData()
        
        // save list in permanent storage
        NSUserDefaults.standardUserDefaults().setObject(locationList, forKey: "locationList")
        NSUserDefaults.standardUserDefaults().setObject(latitudeList, forKey: "latitudeList")
        NSUserDefaults.standardUserDefaults().setObject(longitudeList, forKey: "longitudeList")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("locationList") != nil {
            locationList = NSUserDefaults.standardUserDefaults().objectForKey("locationList") as! [String]
        }
        else {
            print("locationList is empty" )
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("latitudeList") != nil {
            latitudeList = NSUserDefaults.standardUserDefaults().objectForKey("latitudeList") as! [Double]
        }
        else {
            print("latitudeList is empty" )
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("longitudeList") != nil {
            longitudeList = NSUserDefaults.standardUserDefaults().objectForKey("longitudeList") as![Double]
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
    
    // for segue when add button is pressed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            if segue.identifier == "locationTable" {
            }
            else if segue.identifier == "addButton"{
                row = -1
            }
        }
        else {
            print("segue nil")
        }
    }
    
    // whenever table view reappears
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    
    /*-----------------------------*/
    // MARK: - Table view data source

    // sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("location", forIndexPath: indexPath)
        cell.textLabel?.text = locationList[indexPath.row]

        return cell
    }
    
    
    
    // swipe to delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // if swipe to left:
        if editingStyle == UITableViewCellEditingStyle.Delete {
            locationList.removeAtIndex(indexPath.row)
            latitudeList.removeAtIndex(indexPath.row)
            longitudeList.removeAtIndex(indexPath.row)
        }
        
        tableView.reloadData()
        
        NSUserDefaults.standardUserDefaults().setObject(locationList, forKey: "locationList")
        NSUserDefaults.standardUserDefaults().setObject(latitudeList, forKey: "latitudeList")
        NSUserDefaults.standardUserDefaults().setObject(longitudeList, forKey: "longitudeList")
        NSUserDefaults.standardUserDefaults().setObject(locationList, forKey:"locationList")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        row = indexPath.row
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
