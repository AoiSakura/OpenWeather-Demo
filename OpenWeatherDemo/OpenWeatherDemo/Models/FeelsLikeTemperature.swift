//
//  FeelsLikeTemperature.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

struct FeelsLikeTemperature: Decodable {
    var day: Double
    var night: Double
    var evening: Double
    var morning: Double
    
    private enum CodingKeys: String, CodingKey {
        case day
        case night
        case evening = "eve"
        case morning = "morn"
    }
}
