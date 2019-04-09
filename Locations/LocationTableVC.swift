//
//  LocationTableViewController.swift
//  Locations
//
//  Created by Federico Naranjo Bellina on 30/6/16.
//  Copyright © 2016 Rico. All rights reserved.
//

import UIKit
import MapKit
import CoreData

var row = -1    // this value is used for segueing to map location from row, else -1

// Table View with locations
class LocationTableVC: UITableViewController {

    var locations:[Location] = []
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var locationTableView: UITableView!
    @IBOutlet weak var testButton: UIBarButtonItem!
    
    // Clear All button
    @IBAction func ClearButtonTapped(_ sender: AnyObject) {
        clearLocations()
        locations.removeAll()
        tableView.reloadData()
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
    
    // Reload table with any new data
    override func viewWillAppear(_ animated: Bool) {
        getLocations()
        tableView.reloadData()
    }

    // Segue to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        // view controller is passed so it can update view after (async) location added
        let mapVC = segue.destination as! MapVC
        mapVC.tableVC = self
        
        if segue.identifier == "rowSelected" {
            // send specific coordinates
            if let indexPath = self.tableView.indexPathForSelectedRow {
                mapVC.rowLocation = locations[(indexPath as NSIndexPath).row]
                mapVC.rowSegue = true
            }
        }
        else if segue.identifier == "addButton" {
            mapVC.rowSegue = false
        }
        // send all locations for map pins
        mapVC.locations = locations
    }
    
    /// Return the number of sections in table sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    /// Populates rows with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        let location = locations[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = location.address
        
        cell.textLabel?.textColor = UIColor.white
        
        // todo: this is in constants folder?!
        cell.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.37, alpha:1.0)
        return cell
    }
    
    /// Enables swipe left to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // if swipe to left to delete:
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            deleteAtIndexLocationTable(at: (indexPath as NSIndexPath).row)
        }
        
        // update table and stored data
        tableView.reloadData()
    }
    
    /// Action when cell in tableview is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // #todo: remove if not ever used
    }
    
    /// Changes app theme
    func applyTheme() {
        // todo: finish adding colour scheme
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = Style.COLOUR_1
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Style.COLOUR_5]
        self.tableView.backgroundColor = Style.COLOUR_2
        self.tableView.isOpaque = false
        
        // this changes status bar to white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    
    /// takes data saved in CoreData, and popluates the table
    func getLocations() {
        // set up the context for core data
        let context = getContext()
        
        do {
            locations = try context.fetch(Location.fetchRequest()) as! [Location]
        }
        catch {
            print("fetch error in Table View")
        }
    }
    
    /// Clears the locationTable in local data
    func deleteAtIndexLocationTable(at:Int) {
        let context = getContext()
        let location = locations[at]
        locations.remove(at: at)
        context.delete(location)
        saveContext()
    }
    
    /// Clears the locationTable in local data
    func clearLocations() {
        let context = getContext()
        
        for each in locations {
            context.delete(each)
        }

        saveContext()
    }
}

func getContext() -> NSManagedObjectContext{
    // set up the context for core data
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

func saveContext() {
    do{
        try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
    }
    catch {
        print("Could not save Core Data")
    }
}
