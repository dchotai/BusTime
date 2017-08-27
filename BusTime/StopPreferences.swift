//
//  StopPreferences.swift
//  BusTime
//
//  Created by Divyesh Chotai on 8/22/17.
//  Copyright © 2017 Divyesh Chotai. All rights reserved.
//

import Cocoa

class StopPreferences: NSWindowController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    @IBOutlet var prefWindow: NSWindow!
    
    @IBOutlet var addStop: NSWindow!
    
    @IBOutlet weak var routePopup: NSPopUpButton!
    
    @IBOutlet weak var directionPopup: NSPopUpButton!
    
    @IBOutlet weak var stopPopup: NSPopUpButton!
    
    @IBOutlet weak var prefTableView: NSTableView!
    
    weak var api:ACTransitAPI!
    
    var stopsDict = [String:Int]()
    
    let defaults = UserDefaults.standard
    
    weak var menuController : MenuController!
    
    func setMenuController(mc : MenuController) {
        menuController = mc
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        if (segmentedControl.selectedSegment == 0) {
            routePopup.removeAllItems()
            routePopup.addItems(withTitles: ACTransitAPI.routeIDs)
            
            prefWindow.beginSheet(addStop, completionHandler: nil)
        } else {
            let currRow = prefTableView.selectedRow
            var savedStopNames = defaults.object(forKey: "savedStopNames") as? [String] ?? [String]()
            if (currRow != -1) {
                let currName = savedStopNames.remove(at: currRow)
                defaults.set(savedStopNames, forKey: "savedStopNames")
            
                var savedStopIDs = defaults.object(forKey: "savedStopIDs") as? [String:Int] ?? [String:Int]()
                savedStopIDs.removeValue(forKey: currName)
                defaults.set(savedStopIDs, forKey: "savedStopIDs")
            
                prefTableView.reloadData()
                menuController.updateStops()
            }
        }
    }

    
    @IBAction func routeSelect(_ sender: Any) {
        let index = routePopup.indexOfSelectedItem
        
        directionPopup.removeAllItems()
        
        var id : String
        id = ACTransitAPI.routeIDs[index]
        
        api.getRouteDirections(routeID: id) {
            (_ result) -> Void in
            self.directionPopup.addItems(withTitles: result)
            self.directionSelect(Any.self)
        }
    }
    
    
    @IBAction func directionSelect(_ sender: Any) {
        let indexRoute = routePopup.indexOfSelectedItem
        
        stopPopup.removeAllItems()
        
        var idRoute : String
        idRoute = ACTransitAPI.routeIDs[indexRoute]
        
        var dir: String
        dir = directionPopup.titleOfSelectedItem!
        
        var sched: Int
        sched = api.getScheduleType()!
        
        api.getTrip(routeID: idRoute, direction: dir, schedType: sched) {
            (_ result) -> Void in
            
            self.api.getStops(routeID: idRoute, tripID: result) {
                (_ rv) -> Void in

                self.setStopsDict(dict: rv)
                var stopNames = [String]()
                for key in rv.keys {
                    stopNames.append(key)
                }
                
                self.stopPopup.addItems(withTitles: stopNames)
            }
        }
    }
    
    func setStopsDict(dict : [String:Int]) {
        self.stopsDict = dict
    }
    
    
    @IBAction func cancelAddStop(_ sender: Any) {
        prefWindow.endSheet(addStop)
    }
    
    @IBAction func addStop(_ sender: Any) {
        if (self.stopPopup.titleOfSelectedItem != nil) {
            var savedStopNames = defaults.object(forKey: "savedStopNames") as? [String] ?? [String]()
            savedStopNames.append(stopPopup.titleOfSelectedItem!)
            defaults.set(savedStopNames, forKey: "savedStopNames")
            
            var savedStopIDs = defaults.object(forKey: "savedStopIDs") as? [String:Int] ?? [String:Int]()
            savedStopIDs[stopPopup.titleOfSelectedItem!] = self.stopsDict[stopPopup.titleOfSelectedItem!]
            defaults.set(savedStopIDs, forKey: "savedStopIDs")
            
            var savedStopRoutes = defaults.object(forKey: "savedStopRoutes") as? [String:String] ?? [String:String]()
            savedStopRoutes[stopPopup.titleOfSelectedItem!] = routePopup.titleOfSelectedItem!
            defaults.set(savedStopRoutes, forKey: "savedStopRoutes")
            prefTableView.reloadData()
            
            menuController.updateStops()
            
            self.prefWindow.endSheet(addStop)
        }
    }
    
    override var windowNibName : String! {
        return "StopPreferences"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        prefTableView.delegate = self
        prefTableView.dataSource = self
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        let savedNames = defaults.object(forKey: "savedStopNames") as? [String] ?? [String]()
        return savedNames.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let savedNames = defaults.object(forKey: "savedStopNames") as! [String]
        let savedIDs = defaults.object(forKey: "savedStopIDs") as! [String:Int]
        if (savedIDs.count == 0) {
            NSLog("\(savedNames[row]) nonefound")
            return nil
        }
        
        if let cell = tableView.make(withIdentifier: "stopCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "\(savedNames[row])"
            return cell
        }
        return nil
    }

}


