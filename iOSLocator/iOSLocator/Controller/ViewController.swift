//
//  ViewController.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 17/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var locationsTraversed: [CLLocation] = []
    var backgroundLocationsTraversed: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocationToServer(notification:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTurnOnLocationServiceAlert(notification:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
    
    @IBAction func startTracking(_ sender: UIButton) {
       startLocationTracking()
    }
    
    @IBAction func stopTracking(_ sender: UIButton) {
        appDelegate.locationManager.stopUpdatingLocation()
    }
    
    fileprivate func startLocationTracking(){
        appDelegate.locationManager.startUpdatingLocation()
    }
    
    deinit {
        backgroundLocationsTraversed.removeAll()
        locationsTraversed.removeAll()
    }
}

extension ViewController{
    
    @objc func updateLocationToServer(notification: NSNotification){
        /*if let userInfo = notification.userInfo{
            
            if let newLocation = userInfo["location"] as? CLLocation{
                locationsTraversed.append(newLocation)
                if Reachability.isConnectedToNetwork(){
                    NetwrokingManager.postLocationDataToApi(newLocation) { (data, err) in
                        if let _ = data{
                            print("data is posted successfully with \(String(describing: data))")
                        }else{
                            print("error in posting data with \(String(describing: err))")
                        }
                    }
                }else{
                    print("No Internet")
                }
            }
            
        }*/
    }
    
    @objc func showTurnOnLocationServiceAlert(notification: NSNotification){
        let alert = UIAlertController().createSettingsAlertController(title: "Turn on Location Service", message: "To use location tracking feature of the app, please turn on the location service from the Settings app.")

        present(alert, animated: true, completion: nil)
        
    }
    
}
