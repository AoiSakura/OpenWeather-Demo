//
//  OverviewCollectionViewCell.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit
import SDWebImage

class OverviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeTempLabel: UILabel!
    @IBOutlet weak var weatherImageContainerView: UIStackView!
    
    func setupCell(with locationWeather: LocationWeatherInfo) {
        self.dateLabel.text = locationWeather.currentWeatherInfo.date.dateString()
        self.timezoneLabel.text = "Timezone: " + locationWeather.timezone
        self.latitudeLabel.text = String(format: "Latitude: %.1f", locationWeather.latitude)
        self.longtitudLabel.text = String(format: "Longtitude: %.1f", locationWeather.longtitude)
        self.tempLabel.text = String(format: "Temperature: %@", locationWeather.currentWeatherInfo.temp.temperatureString())
        self.feelLikeTempLabel.text = String(format: "Feel Like: %@", locationWeather.currentWeatherInfo.feelsLikeTemp.temperatureString())
        
        for subview in self.weatherImageContainerView.arrangedSubviews {
            self.weatherImageContainerView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        let maxDisplayCount = UIDevice.current.userInterfaceIdiom == .phone ? 4 : 8
        let weathers = locationWeather.currentWeatherInfo.weather
        if weathers.count > maxDisplayCount {
            for index in 0..<maxDisplayCount - 1 {
                let weather = weathers[index]
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                imageView.contentMode = .scaleAspectFit
                imageView.sd_setImage(with: URL(string: weather.imageUrl))
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
