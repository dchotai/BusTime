//
//  StopView.swift
//  BusTime
//
//  Created by Divyesh Chotai on 8/26/17.
//  Copyright © 2017 Divyesh Chotai. All rights reserved.
//

import Cocoa

class StopView: NSView {
    @IBOutlet var contentView: StopView!

    @IBOutlet weak var estTime: NSTextField!
    
    @IBOutlet weak var stopName: NSTextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("StopView", owner: self, topLevelObjects: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
    }
    
    func updateTime(stop: String, time: String, route: String) {
        let separated = stop.components(separatedBy: ":")
        var name = [String]()
        for street in separated {
            name.append(contentsOf: street.components(separatedBy: " ").dropLast())
        }
        
        self.stopName.stringValue = "\(route): " + name.prefix(2).joined(separator: " & ")
//        self.estTime.stringValue = String(format: "%.2f minutes", time)
        self.estTime.stringValue = time + " minutes"
    }
    
}
