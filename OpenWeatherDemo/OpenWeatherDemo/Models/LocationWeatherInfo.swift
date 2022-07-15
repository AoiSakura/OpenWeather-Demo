//
//  LocationWeatherInfo.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

class LocationWeatherInfo: NSObject, Decodable {
    var latitude: Double
    var longtitude: Double
    var timezone: String
    var timezoneOffset: Double
    var currentWeatherInfo: CurrentWeatherInfo
    var daily: [DailyWeatherInfo]
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longtitude = "lon"
        case timezone
        case timezoneOffset = "timezone_offset"
        case currentWeatherInfo = "current"
        case daily
    }
}
