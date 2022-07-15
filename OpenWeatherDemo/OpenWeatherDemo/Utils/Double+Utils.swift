//
//  Double+Utils.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

extension Double {
    func temperatureString() -> String {
        return String(format: "%.1f℃", self)
    }
    
    func percentString() -> String {
        return "\(self)%"
    }
    
    func pressureString() -> String {
        return String(format: "%.1fhPa", self)
    }
    
    func speedString() -> String {
        return String(format: "%.1fm/s", self)
    }
    
    func moonPhaseDescription() -> String? {
        switch self {
            case 0, 1:
                return "New Moon"
            case 0.25:
                return "First Quarter Moon"
            case 0.5:
                return "Full Moon"
            case 0.75:
                return "Last Quarter Moon"
            default:
                if self > 0 && self < 0.25 {
                    return "Waxing Crescent"
                } else if self > 0.25 && self < 0.5 {
                    return "Waxing Gibbous"
                } else if self > 0.5 && self < 0.75 {
                    return "Waning Gibbous"
                } else if self > 0.75 && self < 1 {
                    return "Waning Crescent"
                } else {
                    return nil
                }
        }
    }
}
