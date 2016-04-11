//
//  SensorView.swift
//  Hydroponics
//
//  Created by Said Sikira on 3/28/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import CoreCityOS

class SensorView: UIView {
    
    //MARK: Outlets
    @IBOutlet weak var sensorLabel: UILabel!
    @IBOutlet weak var chartContainerView: ChartView!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    //MARK: Sensor data
    var data: LiveDataType! {
        didSet {
            setupWithData()
        }
    }
    
    func setupWithData() {
        if let data = data {
            setupWithDataPoints(dataPoints: data.dataPoints)
            if let currentDataPoint = data.dataPoints.last {
                let valueString = NSString(format: "%.2f", currentDataPoint.value)
                self.currentValueLabel.text = valueString as String
            }
        }
    }
    
    //MARK: Functions and properties
    func setupWithDataPoints(dataPoints points: [DataPoint]) {
        chartContainerView.dataPoints = points
        chartContainerView.commonInit()
        chartContainerView.setupChart()
        chartContainerView.render()
    }
}
