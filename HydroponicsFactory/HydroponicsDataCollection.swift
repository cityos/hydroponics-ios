//
//  HydroponicsDataCollection.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/6/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import CoreCityOS

extension DataType {
    public static let Float = DataType(dataIdentifier: "Float")
    public static let SoilHumidity = DataType(dataIdentifier: "Soil Humidity")
}

public class HydroponicsDataCollection: LiveDataCollectionType, CustomStringConvertible {
    public var deviceData: DeviceData
    public var creationDate: NSDate
    public var allReadings: [LiveDataType] = []
    
    var temperature: LiveDataType {
        return LiveData(
            dataType: .Temperature,
            jsonKey: "temp",
            unitNotation: "C"
        )
    }
    
    var humidity: LiveDataType {
        return LiveData(
            dataType: .Humidity,
            jsonKey: "humid",
            unitNotation: "%"
        )
    }
    
    var light: LiveDataType {
        return LiveData(
            dataType: .NaturalLight,
            jsonKey: "Light",
            unitNotation: "lux"
        )
    }
    
    var float: LiveDataType {
        return LiveData(
            dataType: .Float,
            jsonKey: "FlowSw1",
            unitNotation: ""
        )
    }
    
    var soilHumidity: LiveDataType {
        return LiveData(
            dataType: .SoilHumidity,
            jsonKey: "Soil",
            unitNotation: "%"
        )
    }
    
    public init(readingID: String) {
        deviceData = DeviceData(deviceID: readingID)
        creationDate = NSDate()
        allReadings = [
            temperature,
            humidity,
            light,
            float,
            soilHumidity
        ]
    }
}
