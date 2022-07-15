//
//  Location.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation
import CoreLocation

struct Location {
    let longtitude: Double
    let latitude: Double
    
    init(location: CLLocation) {
        longtitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
    }
}
