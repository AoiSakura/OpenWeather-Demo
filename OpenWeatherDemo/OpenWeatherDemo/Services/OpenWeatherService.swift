//
//  OpenWeatherService.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit
import Alamofire
import CoreLocation

class OpenWeatherService: NSObject {
    static let baseUrlString = "https://api.openweathermap.org/data/2.5/onecall"
    static let apiKey = "9e251bb0dad51803a42904dbd41f0d54"
    
    static let networkMonitor = NetworkReachabilityManager()
    
    func getWeatherRequest(for location: CLLocation, completionHandler: @escaping ((_ isSuccess: Bool, _ weatherInfo: LocationWeatherInfo?, _ error: Error?) -> Void)) {
        guard var urlComponents = URLComponents(string: OpenWeatherService.baseUrlString) else {
            return
        }
        
        var parameters: [URLQueryItem] = []
        parameters.append(URLQueryItem(name: "appid", value: OpenWeatherService.apiKey))
        parameters.append(URLQueryItem(name: "lon", value: String(location.coordinate.longitude)))
        parameters.append(URLQueryItem(name: "lat", value: String(location.coordinate.latitude)))
        parameters.append(URLQueryItem(name: "exclude", value: "minutely,hourly,alerts"))
        parameters.append(URLQueryItem(name: "units", value: "metric"))
        urlComponents.queryItems = parameters
        
        if let url = urlComponents.url {
            AF.request(url).responseDecodable(of: LocationWeatherInfo.self) { response in
                if let result = response.value {
                    completionHandler(true, result, nil)
                } else {
                    completionHandler(false, nil, response.error)
                }
            }
        }
    }
}
