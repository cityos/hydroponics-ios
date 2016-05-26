//
//  AppDelegate.swift
//  Hydroponics
//
//  Created by Said Sikira on 3/28/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor(
            red:0.11,
            green:0.71,
            blue:0.71,
            alpha:1.00
        )
        
        UINavigationBar.appearance().translucent = false
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(20, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        UITabBar.appearance().tintColor = UIColor(
            red:0.11,
            green:0.71,
            blue:0.71,
            alpha:1.00
        )
        
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            forBarPosition: .Any,
            barMetrics: .Default
        )
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
            ],
            forState: .Normal
        )
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                }
        })
        

        Realm.Configuration.defaultConfiguration = config
        
        dispatch_async(dispatch_get_main_queue(), {
            if let tabBarController = self.window?.rootViewController as? UITabBarController {
                let realm = try? Realm()
                let count = realm?.objects(Notification).count
                tabBarController.tabBar.items?.last?.badgeValue = "\(count ?? 0)"
            }
        })
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print(notification.alertBody)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
