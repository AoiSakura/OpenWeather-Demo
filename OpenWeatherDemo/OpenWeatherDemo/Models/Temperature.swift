//
//  Temperature.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

struct Temperature: Decodable {
    var day: Double
    var min: Double
    var max: Double
    var night: Double
    var evening: Double
    var morning: Double
    
    private enum CodingKeys: String, CodingKey {
        case day
        case min
        case max
        case night
        case evening = "eve"
        case morning = "morn"
    }
}
