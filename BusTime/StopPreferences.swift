//
//  StopPreferences.swift
//  BusTime
//
//  Created by Divyesh Chotai on 8/22/17.
//  Copyright © 2017 Divyesh Chotai. All rights reserved.
//

import Cocoa

class StopPreferences: NSWindowController {
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    @IBOutlet var prefWindow: NSWindow!
    
    @IBOutlet var addStop: NSWindow!
    
    @IBOutlet weak var routePopup: NSPopUpButton!
    
    @IBOutlet weak var directionPopup: NSPopUpButton!
    
    @IBOutlet weak var stopPopup: NSPopUpButton!
    
    weak var api:ACTransitAPI!
    
    var stopsDict = [String:Int]()
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        if (segmentedControl.selectedSegment == 0) {
//            NSLog("plus")
            
            routePopup.removeAllItems()
            routePopup.addItems(withTitles: ACTransitAPI.routeIDs)
            
            prefWindow.beginSheet(addStop, completionHandler: nil)
            
//            prefWindow.endSheet(addStop)
        } else if (segmentedControl.selectedSegment == 1) {
            NSLog("minus")
        } else {
            NSLog("edit")
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
    
    
    override var windowNibName : String! {
        return "StopPreferences"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
}
