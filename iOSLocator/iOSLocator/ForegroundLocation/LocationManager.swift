//
//  LocationManager.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 17/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    var locationManager: CLLocationManager
    
    fileprivate lazy var significantLocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    fileprivate var allowsBackgroundLocationUpdates: Bool {
        didSet {
            locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        }
    }
    
    fileprivate var desiredAccuracy: CLLocationAccuracy {
        didSet {
            locationManager.desiredAccuracy = desiredAccuracy
        }
    }
    
    fileprivate var distanceFilter: CLLocationDistance {
        didSet {
            locationManager.distanceFilter = distanceFilter
        }
    }
    
    fileprivate var backgroundLocations = [CLLocation]() {
        didSet{
            if backgroundLocations.count == 5 {
                begionBackgroundTask(time: 30)
            }
        }
    }
    
    fileprivate var activityType: CLActivityType {
        didSet {
            locationManager.activityType = activityType
        }
    }
    

    fileprivate var lastLocation: CLLocation?
    fileprivate var requestedStatus: LocationAuthorizationStatus?
    fileprivate var locationManagerListener: LocationManagerCompletionHandler?
    fileprivate var backgroundTask = BackGroundTaskManager()
    fileprivate var timer: Timer?

    init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBestForNavigation, distanceFilter: CLLocationDistance = kCLDistanceFilterNone, allowsBackgroundLocationUpdates: Bool = true, activityType:CLActivityType = .fitness) {
        self.desiredAccuracy = desiredAccuracy
        self.distanceFilter = distanceFilter
        self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        self.activityType = activityType
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func startUpdatingLocation(){
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingLocation(){
        lastLocation = nil
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    
    fileprivate func startSignificantLocationChanges() {
        significantLocationManager.delegate = self
        significantLocationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    private func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if requestedStatus?.isAuthorized(for: status) ?? false {
            locationManagerListener?(Result.success(self))
            return
        }
        
        if requestedStatus == .always {
            if status == .authorizedWhenInUse {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                locationManagerListener?(Result.failure(LocationAuthorizationError.cantGetAlways))
            }
        } else {
            locationManagerListener?(Result.failure(LocationAuthorizationError.userDenied))
        }
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        
        if let lastLocation = lastLocation, let newLocation = locations.last {
            if lastLocation.distance(from: newLocation) < 200 || abs(lastLocation.timestamp.timeIntervalSinceNow) < 300 {
                return
            }
        }
        if UIApplication.shared.applicationState != .active {
            backgroundLocations.append(locations.last!)
            notifiyDidUpdateLocation(newLocation: backgroundLocations.last!)
        } else {            
            lastLocation = locations.last
            initialBackgroundTask()
            
            if backgroundLocations.count > 0 {
                backgroundLocations.removeAll()
            }
            notifiyDidUpdateLocation(newLocation: locations.last!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error){
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
            showTurnOnLocationServiceAlert()
        }
    }
    
    private func begionBackgroundTask(time: TimeInterval){
        initialBackgroundTask()
        backgroundLocations.removeAll()
        
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(againStartLocation), userInfo: nil, repeats: false)
        
        backgroundTask.registerBackgroundTask()
    }
    
    private func initialBackgroundTask() {
        if backgroundTask.tasking {
            backgroundTask.endBackgroundTask()
        }
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    @objc func againStartLocation(){
        LocationManager().startUpdatingLocation()
    }
}


extension LocationManager{
    
    func showTurnOnLocationServiceAlert(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
    
    func notifiyDidUpdateLocation(newLocation: CLLocation){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
    }
    
}
