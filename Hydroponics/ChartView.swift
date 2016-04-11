//
//  ChartView.swift
//  Hydroponics
//
//  Created by Said Sikira on 3/28/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import Charts
import CoreCityOS

class ChartView: UIView {
    
    //MARK: View properties
    var dataPoints = [DataPoint]()
    
    //MARK: Auto Layout
    lazy var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.gridBackgroundColor = .clearColor()
        chart.xAxis.enabled = true
        chart.rightAxis.enabled = false
        chart.xAxis.drawAxisLineEnabled = true
        chart.leftAxis.drawAxisLineEnabled = true
        chart.leftAxis.labelTextColor = .blackColor() //UIColor(red:0.36, green:0.43, blue:0.49, alpha:1.00)
        chart.leftAxis.valueFormatter = self.numberFormatter
        chart.leftAxis.drawTopYLabelEntryEnabled = true
        chart.extraTopOffset = 10
        chart.extraLeftOffset = 6
        chart.leftAxis.xOffset = 4
        chart.leftAxis.gridColor = UIColor(red:0.36, green:0.43, blue:0.49, alpha:1.00)
        chart.descriptionText = ""
        chart.highlightPerTapEnabled = false
        chart.highlightPerDragEnabled = false
        chart.setScaleEnabled(false)
        chart.leftAxis.startAtZeroEnabled = false
        chart.noDataText = "Fetching data . . ."
        chart.infoTextColor = UIColor.grayColor()
        chart.userInteractionEnabled = false
        return chart
    }()
    
    
    lazy var numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.roundingMode = .RoundFloor
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var views: [String: UIView] {
        return [
            "chart" : self.chartView
        ]
    }
    
    func render() {
        assert(self.dataPoints.count != 0, "Data points are not added")
        UIView.animateWithDuration(0.4) {
            self.alpha = 1
        }
    }
    
    func setupConstraints() {
        self.addSubview(chartView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[chart]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[chart]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        
        constraints.activateConstraints()
    }
    
    func setupChart() {
        var xValues = [Int]()
        for i in 0..<dataPoints.count {
            xValues.append(i)
        }
        
        var yValues = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            yValues.append(ChartDataEntry(value: self.dataPoints[i].value, xIndex: i))
        }
        
        let set = createDataSet(xValues, yValues: yValues)
        
        let data = LineChartData(xVals: xValues, dataSet: set)
        self.chartView.data = data
//        self.chartView.animate(xAxisDuration: 0.4)
        self.render()
    }
    
    func createDataSet(xValues: [Int], yValues: [ChartDataEntry]) -> LineChartDataSet {
        let set = LineChartDataSet(yVals: yValues, label: "Values")
        
        set.drawCubicEnabled = true
        set.lineWidth = 2
        set.circleRadius = 0
        set.drawValuesEnabled = false
        set.colors = [UIColor(red:0.11, green:0.71, blue:0.71, alpha:1.00)]
        return set
    }
    
    internal class func randomDouble() -> Double {
        func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
            return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
        }
        let number = Double(randomBetweenNumbers(1, secondNum: 50))
        return round(1000*number)/1000
    }
    
    internal class func randomDataPoints(size: Int) -> [DataPoint] {
        var points = [DataPoint]()
        for _ in 0..<size {
            points.append(DataPoint(value: randomDouble()))
        }
        return points
    }
    
    //MARK: Init methods
    func commonInit() {
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
        self.setupConstraints()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    init(dataPoints points: DataPoint...) {
        super.init(frame: CGRect.zero)
        self.dataPoints = points
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
