//
//  NotificationsTableViewController.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/8/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import RealmSwift
import HydroponicsFactory

class NotificationsTableViewController: UITableViewController {
    
    var realm: Realm!
    var notifications = [Notification]()
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        
        realm = try! Realm()
        
        HydroponicsFactory.sharedInstance.subsribeToNotifications {
            payload in
            
            let notification = Notification()
            notification.notificationString = payload
            
            try! realm.write {
                realm.add(notification)
            }
            
            tableView.reloadData()
            sendLocalNotification(payload)
        }
        
        let realmNotifications = realm.objects(Notification)
        notifications = realmNotifications.map { $0 }
        
        let clearAllButton = UIBarButtonItem(
            title: "Clear all",
            style: .Plain,
            target: self,
            action: #selector(clearAllNotifications)
        )
        
        navigationItem.rightBarButtonItem = clearAllButton
        tabBarController?.tabBar.items?.last?.badgeValue = "\(notifications.count)"
    }
    
    func clearAllNotifications() {
        try! realm.write {
            realm.deleteAll()
        }
        notifications = []
        tabBarController?.tabBar.items?.last?.badgeValue = "0"
        tableView.reloadData()
    }
    
    func sendLocalNotification(payload: NotificationPayload) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = payload
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = notifications.count
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath)

        cell.textLabel?.text = notifications[indexPath.row].notificationString
        cell.detailTextLabel?.text = NotificationsTableViewController.dateFormatter.stringFromDate(notifications[indexPath.row].time)
        return cell
    }
}
