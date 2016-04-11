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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath)

        cell.textLabel?.text = notifications[indexPath.row].notificationString
        cell.detailTextLabel?.text = NotificationsTableViewController.dateFormatter.stringFromDate(notifications[indexPath.row].time)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
