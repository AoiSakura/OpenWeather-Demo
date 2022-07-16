//
//  TimeInterval+Utils.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import Foundation

extension TimeInterval {
    func timestampToDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
