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
        api.getRoutes()
    }
    
    @IBAction func prefClicked(_ sender: NSMenuItem) {
//        statusMenu.insertItem(NSMenuItem.separator(), at: 0)
//        statusMenu.insertItem(NSMenuItem(title: "hello", action: nil, keyEquivalent: ""), at: 0)
        stopPrefs.showWindow(nil)
        stopPrefs.api = api
    }

}
