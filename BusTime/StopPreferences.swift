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
    @IBAction func segmentedControlAction(_ sender: Any) {
        if (segmentedControl.selectedSegment == 0) {
            NSLog("plus")
            prefWindow.beginSheet(addStop, completionHandler: nil)
            
//            prefWindow.endSheet(addStop)
        } else if (segmentedControl.selectedSegment == 1) {
            NSLog("minus")
        } else {
            NSLog("edit")
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
    }
    
}
