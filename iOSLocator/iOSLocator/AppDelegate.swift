//
//  AppDelegate.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 17/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = LocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }


}

