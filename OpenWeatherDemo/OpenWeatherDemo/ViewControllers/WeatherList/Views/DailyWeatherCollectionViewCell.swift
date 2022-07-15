//
//  DailyWeatherCollectionViewCell.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit

class DailyWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherImageContainerView: UIStackView!
    
    func setup(with dailyWeather: DailyWeatherInfo) {
        self.dateLabel.text = dailyWeather.date.dateString()
        self.maxTempLabel.text = String(format: "Max: %@", dailyWeather.temp.max.temperatureString())
        self.minTempLabel.text = String(format: "Min: %@", dailyWeather.temp.min.temperatureString())
        
        for subview in self.weatherImageContainerView.arrangedSubviews {
            self.weatherImageContainerView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        let maxDisplayCount = UIDevice.current.userInterfaceIdiom == .phone ? 4 : 8
        let weathers = dailyWeather.weather
        if weathers.count > maxDisplayCount {
            for index in 0..<maxDisplayCount - 1 {
                let weather = weathers[index]
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                imageView.sd_setImage(with: URL(string: weather.imageUrl))
                imageView.contentMode = .scaleAspectFit
                self.weatherImageContainerView.addArrangedSubview(imageView)
            }
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(systemName: "ellipsis")
            self.weatherImageContainerView.addArrangedSubview(imageView)
        } else {
            for index in 0..<weathers.count {
                let weather = weathers[index]
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                imageView.contentMode = .scaleAspectFit
                imageView.sd_setImage(with: URL(string: weather.imageUrl))
                self.weatherImageContainerView.addArrangedSubview(imageView)
            }
        }
    }
}
