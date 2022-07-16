//
//  WeatherCollectionViewCell.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/16.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    func setup(with weather: Weather) {
        self.imageView.sd_setImage(with: URL(string: weather.imageUrl))
        self.weatherLabel.text = weather.description
    }
}
