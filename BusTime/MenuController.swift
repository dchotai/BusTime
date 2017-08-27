//
//  MenuController.swift
//  BusTime
//
//  Created by Divyesh Chotai on 8/19/17.
//  Copyright © 2017 Divyesh Chotai. All rights reserved.
//

import Cocoa

class MenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    var stopPrefs = StopPreferences()
    
    let defaults = UserDefaults.standard
        
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    let api = ACTransitAPI()
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        stopPrefs = StopPreferences()
        stopPrefs.setMenuController(mc: self)
        api.getRoutes()
        
        
//        defaults.removeObject(forKey: "savedStopNames")
//        defaults.removeObject(forKey: "savedStopIDs")
//        defaults.removeObject(forKey: "savedStopRoutes")
    }
    
    @IBAction func prefClicked(_ sender: NSMenuItem) {
        stopPrefs.showWindow(nil)
        stopPrefs.api = api
    }
    
    func updateStops() {
        let savedStopNames = defaults.object(forKey: "savedStopNames") as? [String] ?? [String]()
        let savedStopIDs = defaults.object(forKey: "savedStopIDs") as? [String:Int] ?? [String:Int]()
        let savedStopRoutes = defaults.object(forKey: "savedStopRoutes") as? [String:String] ?? [String:String]()
        
        
        
        let keep = Array(statusMenu.items.suffix(3))
        statusMenu.removeAllItems()
        for item in keep {
            statusMenu.addItem(item)
        }
        
        if (savedStopNames.count > 0) {
            for name in savedStopNames {
                
                api.getPrediction(stopID: savedStopIDs[name]!) {
                    (_ rv) -> Void in
                    let newitem = NSMenuItem()
                    let sv = StopView(frame: NSRect(x:0, y:0, width:175, height:40))
                    sv.updateTime(stop: name, time: rv, route: "\(savedStopRoutes[name]!)")
                    
                    newitem.view = sv
                    self.statusMenu.insertItem(NSMenuItem.separator(), at: 0)
                    self.statusMenu.insertItem(newitem, at: 0)
                }
                
            }
        }

    }
    
}
