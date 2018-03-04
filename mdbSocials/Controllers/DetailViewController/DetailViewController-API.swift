//
//  DetailViewController-API.swift
//  mdbSocials
//
//  Created by Fang on 3/3/18.
//  Copyright © 2018 fang. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        self.latitude = userLocation.coordinate.latitude
        self.longitude = userLocation.coordinate.longitude
        
        var weatherData = Alamofire.request("https://api.darksky.net/forecast/c9d8d8010cdba16d113bbfbcacab0d29/" + String(latitude) + "," + String(longitude)).responseJSON { response in
            if let json = response.result.value {
                let json2 = JSON(json)
                
                self.status = json2["currently"]["summary"].stringValue
                self.precip = json2["minutely"]["data"][0]["precipType"].string
                self.rainTime = json2["minutely"]["data"][0]["time"].double
                
                if self.precip != "rain" {
                    self.weather.text = "It will not rain in the next hour."
//                    self.weather.text = String(self.currentDesc)

                } else {
                    self.weather.text = "It will rain at " + String(describing: NSDate(timeIntervalSince1970: self.rainTime)) + "!"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
