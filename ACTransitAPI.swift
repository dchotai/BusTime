//
//  ACTransitAPI.swift
//  BusTime
//
//  Created by Divyesh Chotai on 8/19/17.
//  Copyright © 2017 Divyesh Chotai. All rights reserved.
//

import Foundation

class ACTransitAPI {
    let TOKEN = "?token=E8B5BCE12863B6FF772C0D59FB2843AF" //token from demo
    let BASEURL = "http://api.actransit.org/transit/"
    
    func getScheduleType() -> Int? {
        let day = Calendar.current.component(.weekday, from: Date())
        
        if (day == 1) { //Sunday is 1 in Swift, 6 in API
            return 6
        } else if (day == 7) { //Saturday is 7 in Swift, 5 in API
            return 5
        } else {  //Weekdays are 0 in API
            return 0
        }
    }
    
    func getRoutes() {
        let session = URLSession.shared
        let url = URL(string: "\(BASEURL)routes/\(TOKEN)")
        
        let task = session.dataTask(with: url!) { data, response, error in
            if let e = error {
                NSLog("API Error: \(e)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200){
                    if let routes = self.parseRouteIDs(data!) {
                        NSLog("\(routes)")
                    }
                } else {
                    NSLog("API Error: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func parseRouteIDs(_ data: Data) -> [String]? {
        let json: [[String:AnyObject]]
        
        do {
            json = try JSONSerialization.jsonObject(with: data) as! [[String:AnyObject]]
        } catch {
            NSLog("Route parsing error")
            return nil
        }
        
        var routes = [String]()
        
        for item in json {
            let routeID = item["RouteId"] as! String
            routes.append(routeID)
        }
        
        return routes
    }
}
