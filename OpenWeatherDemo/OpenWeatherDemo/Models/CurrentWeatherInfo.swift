//
//  CurrentWeatherInfo.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

class CurrentWeatherInfo: NSObject, Decodable {
    struct Rain: Decodable {
        var lastHourVolume: Double?
        
        private enum CodingKeys: String, CodingKey {
            case lastHourVolume = "1h"
        }
    }
    
    struct Snow: Decodable {
        var lastHourVolume: Double?
        
        private enum CodingKeys: String, CodingKey {
            case lastHourVolume = "1h"
        }
    }
    
    var timestamp: TimeInterval // Time of the forecasted data, Unix, UTC
    var sunrise: TimeInterval // Sunrise time, Unix, UTC
    var sunset: TimeInterval // Sunset time, Unix, UTC
    
    var temp: Double
    var feelsLikeTemp: Double
    var pressure: Double // Atmospheric pressure on the sea level, hPa
    var humidity: Double // Humidity, %
    var dewPoint: Double // Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form.
    
    var windSpeed: Double // Wind speed. metre/sec
    var windGust: Double? // (where available) Wind gust. metre/sec
    var windDeg: Double // Wind direction, degrees (meteorological)
    
    var clouds: Double // Cloudiness, %
    var uvi: Double // The maximum value of UV index for the day
    var visibility: Double // Average visibility, metres. The maximum value of the visibility is 10km
    
    var rain: Rain? // (where available) Precipitation volume, mm
    var snow: Snow? // (where available) Snow volume, mm
    
    var weather: [Weather]
    
    var date: Date {
        get {
            return timestamp.timestampToDate()
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case sunrise
        case sunset
        case temp
        case feelsLikeTemp = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDeg = "wind_deg"
        case clouds
        case uvi
        case visibility
        case rain
        case snow
        case weather
    }
}
