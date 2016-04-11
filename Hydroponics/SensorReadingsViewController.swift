//
//  ViewController.swift
//  Hydroponics
//
//  Created by Said Sikira on 3/28/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import CoreCityOS
import HydroponicsFactory

class SensorReadingsViewController: UIViewController {
    
    //MARK: Views
    @IBOutlet weak var timeRangeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var refreshControl = UIRefreshControl()
    var containerView: UIView!
    
    var temperatureView: SensorView!
    var humidityView: SensorView!
    var lightView: SensorView!
    var soilHumidityView: SensorView!
    
    var device: DeviceType! {
        didSet {
            updateViewsWithDevice()
        }
    }
    
    func setupSensorViews() {
        temperatureView = UIView.loadFromNibNamed("SensorView") as! SensorView
        humidityView = UIView.loadFromNibNamed("SensorView") as! SensorView
        lightView = UIView.loadFromNibNamed("SensorView") as! SensorView
        soilHumidityView = UIView.loadFromNibNamed("SensorView") as! SensorView
        
        temperatureView.translatesAutoresizingMaskIntoConstraints = false
        humidityView.translatesAutoresizingMaskIntoConstraints = false
        lightView.translatesAutoresizingMaskIntoConstraints = false
        soilHumidityView.translatesAutoresizingMaskIntoConstraints = false
        
        temperatureView.layer.cornerRadius = 6
        humidityView.layer.cornerRadius = 6
        lightView.layer.cornerRadius = 6
        soilHumidityView.layer.cornerRadius = 6
        
        temperatureView.sensorLabel.text = "Temperature"
        humidityView.sensorLabel.text = "Humidity"
        lightView.sensorLabel.text = "Light"
        soilHumidityView.sensorLabel.text = "Soil humidity"
        
//        temperatureView.currentValueLabel.text = "22.5 Celsius"
//        humidityView.currentValueLabel.text = "56 %"
//        lightView.currentValueLabel.text = "224 lux"
    }
    
    func setupScrollView() {
        self.scrollView.layoutIfNeeded()
        let frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 992)
        containerView = UIView(frame: frame)
        
        scrollView.contentSize = containerView.bounds.size
        scrollView.addSubview(containerView)
        
        containerView.addSubview(temperatureView)
        containerView.addSubview(humidityView)
        containerView.addSubview(lightView)
        containerView.addSubview(soilHumidityView)
        
        var views = [String:AnyObject]()
        views.updateValue(temperatureView, forKey: "temp")
        views.updateValue(humidityView, forKey: "hum")
        views.updateValue(lightView, forKey: "light")
        views.updateValue(soilHumidityView, forKey: "soil")
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[temp]-|", options: [], metrics: nil, views: views))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[hum]-|", options: [], metrics: nil, views: views))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[light]-|", options: [], metrics: nil, views: views))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[soil]-|", options: [], metrics: nil, views: views))
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[temp(240)]-[hum(240)]-[light(240)]-[soil(240)]",
            options: [],
            metrics: nil,
            views: views
            )
        )
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        
    }
    
    func didChangeTimeRange(control: UISegmentedControl) {
        let range = TimeRange(rawValue: control.selectedSegmentIndex)
        
        if let range = range {
            self.retrieveDataForTimeRange(timeRange: range)
            UIView.animateWithDuration(0.6, animations: {
                self.containerView.alpha = 0
            }) {
                _ in
                self.temperatureView.timeAgoLabel.text = range.timeAgo
                self.humidityView.timeAgoLabel.text = range.timeAgo
                self.soilHumidityView.timeAgoLabel.text = range.timeAgo
                self.lightView.timeAgoLabel.text = range.timeAgo
            }
        }
    }
    
    func retrieveDataForTimeRange(timeRange range: TimeRange) {
        
        HydroponicsFactory.sharedInstance.requestDataInTimeRange(timeRange: range) {
            devices, error in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.animateWithDuration(0.6, animations: {
                        self.containerView.alpha = 1
                    }) {_ in
                        
                    }
                })
                
                if let device = devices?.first {
                    self.device = device
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func updateViewsWithDevice() {
        if let device = device {
            dispatch_async(dispatch_get_main_queue(), {
                self.temperatureView.data = device.dataCollection[.Temperature]!
                self.humidityView.data = device.dataCollection[.Humidity]!
                self.lightView.data = device.dataCollection[.NaturalLight]!
                self.soilHumidityView.data = device.dataCollection[.SoilHumidity]!
            })
            
        }
    }
    
    ///MARK: Refreshing
    func addRefreshControlToScrollView() {
        scrollView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        retrieveDataForTimeRange(timeRange: .Days)
        
    }
    
    //MARK: View delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSensorViews()
        setupScrollView()
        addRefreshControlToScrollView()
        
        timeRangeSegmentedControl.addTarget(
            self,
            action: #selector(didChangeTimeRange(_:)),
            forControlEvents: .ValueChanged
        )
        
        retrieveDataForTimeRange(timeRange: .Days)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(refreshWithTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func refreshWithTimer(timer: NSTimer) {
        retrieveDataForTimeRange(timeRange: .Days)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
