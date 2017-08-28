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
    
    static var routeIDs = [String]()
    
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
                        ACTransitAPI.routeIDs = routes
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
    
    func getRouteDirections(routeID: String, completion: @escaping (_ result: [String]) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "\(BASEURL)route/\(routeID)/directions/\(TOKEN)")
        
        let task = session.dataTask(with: url!) { data, response, error in
            if let e = error {
                NSLog("API Error: \(e)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200){
                    if let directions = self.parseRouteDirections(data!) {
                        completion(directions)
                    }
                } else {
                    NSLog("API Error: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func parseRouteDirections(_ data: Data) -> [String]? {
        let json: [String]
        
        do {
            json = try JSONSerialization.jsonObject(with: data) as! [String]
        } catch {
            NSLog("Direction parsing error")
            return nil
        }
        
        var directions = [String]()
        
        let count = json.count
        var i = 1
        
        if (count < 2) {
            directions.append(json[0])
        } else {
            while (i < count) {
                directions.append(json[i])
                i += 2
            }
        }
        return directions
    }
    
    func getTrip(routeID: String, direction:String, schedType:Int, completion: @escaping (_ result: Int) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "\(BASEURL)route/\(routeID)/trips/\(TOKEN)&direction=\(direction)&scheduleType=\(schedType)")
        
        let task = session.dataTask(with: url!) { data, response, error in
            if let e = error {
                NSLog("API Error: \(e)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200){
                    if let trip = self.parseTrips(data!) {
                        completion(trip)
                    }
                } else {
                    NSLog("API Error: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func parseTrips(_ data: Data) -> Int? {
        let json: [[String:AnyObject]]
        
        do {
            json = try JSONSerialization.jsonObject(with: data) as! [[String:AnyObject]]
        } catch {
            NSLog("Direction parsing error")
            return nil
        }
        
        let tripID = json[0]["TripId"] as! Int
        return tripID
    }
    
    func getStops(routeID:String, tripID: Int, completion: @escaping (_ rv: [String:Int]) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "\(BASEURL)route/\(routeID)/trip/\(tripID)/stops/\(TOKEN)")

        let task = session.dataTask(with: url!) { data, response, error in
            if let e = error {
                NSLog("API Error: \(e)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200){
                    if let stops = self.parseStops(data!) {
                        completion(stops)
                    }
                } else {
                    NSLog("API Error: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func parseStops(_ data: Data) -> [String:Int]? {
        let json: [[String:AnyObject]]
        
        do {
            json = try JSONSerialization.jsonObject(with: data) as! [[String:AnyObject]]
        } catch {
            NSLog("Direction parsing error")
            return nil
        }
        
        var dict = [String: Int]()
        
        for item in json {
            var name: String
            name = item["Name"] as! String
            
            var stopid : Int
            stopid = item["StopId"] as! Int
            dict[name] = stopid
        }
        return dict
    }
    
    func getPrediction(stopID: Int, routeID: String, completion: @escaping (_ rv: String) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "\(BASEURL)stops/\(stopID)/predictions/\(TOKEN)")
        
        let task = session.dataTask(with: url!) { data, response, error in
            if let e = error {
                NSLog("API Error: \(e)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200){
                    if let prediction = self.parsePredictions(data!, routeID: routeID) {
                        completion(prediction)
                    }
                } else {
                    NSLog("API Error: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()

    }
    
    func parsePredictions(_ data: Data, routeID: String) -> String? {
        let json: [[String:AnyObject]]
        
        do {
            json = try JSONSerialization.jsonObject(with: data) as! [[String:AnyObject]]
        } catch {
            NSLog("Direction parsing error")
            return nil
        }
        
        var est = ""
        
        for item in json.reversed() {
            if (item["RouteName"] as! String == routeID) {
                est = item["PredictedDeparture"] as! String
            }
        }
        
        if (est == "") {
            return "Stop inactive"
        }
        
        let time = est.components(separatedBy: "T")[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var fullEstDate = dateFormatter.date(from: time)

        
        let curr = Date()
        
        let cal = Calendar.current
        var components = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fullEstDate!)
        components.year = cal.component(.year, from: curr)
        components.month = cal.component(.month, from: curr)
        components.day = cal.component(.day, from: curr)
        fullEstDate = cal.date(from: components)!
        
        
        let diff = fullEstDate!.timeIntervalSince(curr)
        let minSec = DateComponentsFormatter()
        minSec.allowedUnits = [.minute, .second]
        minSec.unitsStyle = .positional

        return minSec.string(from: diff)
    }
    
}
