//
//  Helper.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 18/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

typealias LocationManagerCompletionHandler = (Result<LocationManager,LocationAuthorizationError>) -> ()


enum LocationAuthorizationStatus {
    case whenInUse
    case always
    
    func authorizationStatus() -> CLAuthorizationStatus {
        switch self {
        case .always:
            return .authorizedAlways
        case .whenInUse:
            return .authorizedWhenInUse
        }
    }
    
    func isAuthorized(for status: CLAuthorizationStatus) -> Bool {
        if status == authorizationStatus() {
            return true
        }
        
        if status == .authorizedAlways && self == .whenInUse {
            return true
        }
        
        return false
    }
}


enum LocationAuthorizationError: Error {
    case cantGetAlways
    case userDenied
}

enum GenericError: Error{
    case error
}


extension CLLocationCoordinate2D {
    
    func location(for bearing:Double, and distanceMeters:Double) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) 
        
        let lat1 = latitude * Double.pi / 180
        let lon1 = longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}


extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension UIAlertController {
    func createSettingsAlertController(title: String, message: String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:"" ), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment:"" ), style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        controller.addAction(cancelAction)
        controller.addAction(settingsAction)
        
        return controller
    }
}
