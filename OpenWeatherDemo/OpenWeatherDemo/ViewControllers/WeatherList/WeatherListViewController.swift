//
//  WeatherListViewController.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit
import MBProgressHUD
import CoreLocation

class WeatherListViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private lazy var weatherService = OpenWeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
    }

    @IBAction func userTouchedRequestLocationButton(_ sender: Any) {
        self.getCurrentLocation()
    }
    
    func getCurrentLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestLocation()
        }
    }
    
    func fetchWeatherData() {
        if let location = self.currentLocation {
            self.weatherService.getWeatherRequest(for: location) { isSuccess, error in
                
            }
        }
    }
}

extension WeatherListViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            default:
                _ = MBProgressHUD.showHud(to: self.view, message: "Premission Unauthorized", timeDelay: 1, animated: true, completionBlock: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _ = MBProgressHUD.showHud(to: self.view, message: "Acquire Location Failed", timeDelay: 1, animated: true, completionBlock: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first
        self.fetchWeatherData()
    }
}
