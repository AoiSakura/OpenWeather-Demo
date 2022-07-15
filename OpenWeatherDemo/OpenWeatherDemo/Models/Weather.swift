//
//  Weather.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    var imageUrl: String {
        get {
            let imageUrlPattern = "https://openweathermap.org/img/wn/%@@2x.png"
            return String(format: imageUrlPattern, self.icon)
        }
    }
}
