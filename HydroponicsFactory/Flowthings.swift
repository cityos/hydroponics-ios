//
//  Flowthings.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/6/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import CoreCityOS

internal typealias FTGeolocation = (latitude: Double, longitude: Double)
internal typealias FTEelems = Dictionary<String, AnyObject>
internal typealias FTCompletionBlock = (device: Hydroponics?, error: ErrorType?) -> ()

enum FlowthingsError: ErrorType {
    case BadData
    case EmptyData(String)
}

internal class Flowthings {
    
    static var session = NSURLSession.sharedSession()
    
    class func requestLatestData(completion: FTCompletionBlock) {
        guard let URL = NSURL(string: "https://api.flowthings.io/v0.1/ceco/drop/f5704ee825bb7095f5e3b05c1?hints=0")
            else { return }
        
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("F3KIjZaOD7rB9RCjrFog5UcrXh9I", forHTTPHeaderField: "X-Auth-Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = Flowthings.session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(device: nil, error: error!)
            } else {
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    let device = try serializeData(jsonData)
                    completion(device: device, error: nil)
                } catch {
                    completion(device: nil, error: error)
                }
            }
        
        }
        
        task.resume()
    }
    
    class func serializeData(data: AnyObject) throws -> Hydroponics {
        guard let body = data["body"] as? [Dictionary<String, AnyObject>] else {
            throw FlowthingsError.BadData
        }
        
        let id = "12345"
        let device = Hydroponics(deviceID: id)
        
        let jsonKeys = device.dataCollection.allReadings.map { $0.jsonKey }
        
        for record in body {
            guard let elems = record["elems"] as? [String: AnyObject] else {
                throw FlowthingsError.EmptyData("No data in elems dictionary")
            }
            
            for key in jsonKeys {
                device.dataCollection[key]?.addDataPoint(DataPoint(value: elems[key] as! Double))
            }
        }
        return device
    }
}
