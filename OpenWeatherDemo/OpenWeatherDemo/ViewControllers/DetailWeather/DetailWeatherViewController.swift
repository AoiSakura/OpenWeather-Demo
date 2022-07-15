//
//  DetailWeatherViewController.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit

class DetailWeatherViewController: UIViewController {

    var dailyWeather: DailyWeatherInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(dailyWeather)
    }
}
