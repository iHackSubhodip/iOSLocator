//
//  BackGroundTaskManager.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 19/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import UIKit

class BackGroundTaskManager {
    
    var taskInvalid = UIBackgroundTaskIdentifier.invalid
    var tasking = false
    var timeOut = false
    
    func registerBackgroundTask() {
        tasking = true
        taskInvalid = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            [unowned self] in
            self.timeOut = true
            self.endBackgroundTask()
        })
        LocationManager().stopUpdatingLocation()
//        print("register backgroundtask")
    }
    
    func endBackgroundTask() {
        if timeOut {
            LocationManager().startUpdatingLocation()
        }
        tasking = false
        UIApplication.shared.endBackgroundTask(taskInvalid)
        taskInvalid = UIBackgroundTaskIdentifier.invalid
//        print("end backgroundtask")
    }
    
}
