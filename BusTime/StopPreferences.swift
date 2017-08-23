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
        }
    }
    
    
    @IBAction func directionSelect(_ sender: Any) {

        
        
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
