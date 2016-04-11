//
//  Extensions.swift
//  Hydroponics
//
//  Created by Said Sikira on 3/28/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil) -> UIView? {
        return UINib(
                nibName: nibNamed,
                bundle: bundle
            )
            .instantiateWithOwner(
                nil,
                options: nil
            )[0] as? UIView
    }
}

extension CollectionType where Generator.Element == NSLayoutConstraint {
    func activateConstraints() {
        NSLayoutConstraint.activateConstraints(self as! [NSLayoutConstraint])
    }
    
    func deactivateConstraints() {
        NSLayoutConstraint.deactivateConstraints(self as! [NSLayoutConstraint])
    }
}

extension UINavigationController {
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
