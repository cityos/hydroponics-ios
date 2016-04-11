//
//  TimeRange.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/6/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

public enum TimeRange: Int {
    case Minutes
    case Hours
    case Days
    case Months
    
    public var timeAgo: String {
        switch self {
        case .Minutes:
            return "Last 60 minutes"
        case .Hours:
            return "Last 24 hours"
        case .Days:
            return "Last month"
        case .Months:
            return "Last year"
        }
    }
    
    public var identifier: String {
        switch self {
        case .Minutes:
            return "minute"
        case .Hours:
            return "hour"
        case .Days:
            return "day"
        case .Months:
            return "month"
            
        }
    }
}
