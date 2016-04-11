//
//  Notification.swift
//  Hydroponics
//
//  Created by Said Sikira on 4/8/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class Notification: Object {
    dynamic var notificationString = ""
    dynamic var time = NSDate()
}
