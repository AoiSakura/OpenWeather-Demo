//
//  Date+Utils.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

extension Date {
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/d EEEE"
        return formatter
    }
    
    static func timeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    func dateString() -> String {
        return Date.dateFormatter().string(from: self)
    }
    
    func timeString() -> String {
        return Date.timeFormatter().string(from: self)
    }
}
