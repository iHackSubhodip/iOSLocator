//
//  NetwrokingManager.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 18/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import CoreLocation
import UIKit

typealias JSONTaskCompletionHandler = (Any?, GenericError?) -> Void

final class NetwrokingManager{
    
    class func postLocationDataToApi(_ location: CLLocation, completionHandler completion: @escaping JSONTaskCompletionHandler) {
        
        let username = "test/candidate"
        let password = "c00e-4764"
        
        let url = NSURL(string: "https://api.locus.sh/v1//client/test/user/candidate/location")
        let request = NSMutableURLRequest(url: url! as URL)
        
        let parameters = [
            "location": [
                "lat": "\(location.coordinate.latitude)",
                "lng": "\(location.coordinate.longitude)"
            ]
        ]
//        print("location.coordinate is \(location.coordinate.latitude)")
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.httpBody = postData
        let config = URLSessionConfiguration.default
        let userPasswordString = "\(username):\(password)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["content-type": "application/json","Authorization" : authString]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                if let data = data {
                    completion(data, nil)
                } else {
                    completion(nil, .error)
                }
            } else {
                completion(nil, .error)
            }
        }
        task.resume()
    }

}
