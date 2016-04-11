//
//  HydroponicsDevice.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/6/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import CoreCityOS

public class Hydroponics: DeviceType, CustomStringConvertible {
    public var creationDate: NSDate?
    public var dataCollection: LiveDataCollectionType
    public var location: DeviceLocation?
    public var deviceData: DeviceData
    
    public init(deviceID: String) {
        deviceData = DeviceData(deviceID: deviceID)
        dataCollection = HydroponicsDataCollection(readingID: deviceID)
        creationDate = NSDate()
    }
}
