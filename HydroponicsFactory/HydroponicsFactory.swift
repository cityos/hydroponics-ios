//
//  HydroponicsFactory.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/6/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import CoreCityOS

public typealias HydroponicsFactroryResult = (devices: [DeviceType]?, error: ErrorType?) -> Void
public typealias NotificationPayload = String

final public class HydroponicsFactory: FactoryType {
    public static let sharedInstance = HydroponicsFactory()
    
    public func requestDataInTimeRange(timeRange range: TimeRange, completion: HydroponicsFactroryResult) {
        Flowthings.requestLatestData {
            data in
            if let error = data.error {
                completion(devices: nil, error: error)
            } else {
                if let device = data.device {
                    completion(devices: [device], error: nil)
                }
            }
        }
    }
    
    public func subsribeToNotifications(@noescape completion: (NotificationPayload -> ())) {
        completion("Temperature is above 20 degress celsius")
    }
}
