//
//  DailyWeatherInfo.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

class DailyWeatherInfo: NSObject, Decodable {
    var timestamp: TimeInterval // Time of the forecasted data, Unix, UTC
    var sunrise: TimeInterval // Sunrise time, Unix, UTC
    var sunset: TimeInterval // Sunset time, Unix, UTC
    
    var moonrise: TimeInterval // The time of when the moon rises for this day, Unix, UTC
    var moonset: TimeInterval // The time of when the moon sets for this day, Unix, UTC
    var moonPhase: Double // Moon phase. 0 and 1 are 'new moon', 0.25 is 'first quarter moon', 0.5 is 'full moon' and 0.75 is 'last quarter moon'. The periods in between are called 'waxing crescent', 'waxing gibous', 'waning gibous', and 'waning crescent', respectively.
    
    var temp: Temperature
    var feelsLikeTemp: FeelsLikeTemperature
    
    var pressure: Double // Atmospheric pressure on the sea level, hPa
    var humidity: Double // Humidity, %
    var dewPoint: Double // Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form.
    
    var windSpeed: Double // Wind speed. metre/sec
    var windGust: Double? // (where available) Wind gust. metre/sec
    var windDeg: Double // Wind direction, degrees (meteorological)
    
    var clouds: Double // Cloudiness, %
    var uvi: Double // The maximum value of UV index for the day
    var pop: Double // Probability of precipitation. The values of the parameter vary between 0 and 1, where 0 is equal to 0%, 1 is equal to 100%
    
    var rain: Double? // (where available) Precipitation volume, mm
    var snow: Double? // (where available) Snow volume, mm
    
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
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
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
        case pop
        case rain
        case snow
        case weather
    }
}
