//
//  DetailWeatherViewController.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit

class DetailWeatherViewController: UIViewController {
    enum Section: Int, Hashable, CaseIterable {
        case weather, list
    }

    struct Item: Hashable {
        var weather: Weather?
        var image: UIImage?
        var title: String?
        var description: String?
        let identifier = UUID()
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        init(with newWeahter: Weather) {
            self.weather = newWeahter
        }
        
        init(image: UIImage? = nil, title: String? = nil, description: String? = nil) {
            self.image = image
            self.title = title
            self.description = description
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dailyWeather: DailyWeatherInfo?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.applySnapshots()
    }
    
    func configureUI() {
        self.collectionView.collectionViewLayout = self.createCollectionViewLayout()
        self.configureDataSource()
    }
}

extension DetailWeatherViewController {
    func applySnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(self.createWeatherItems(), toSection: .weather)
        snapshot.appendItems(self.createListItems(), toSection: .list)
        
        self.dataSource.apply(snapshot)
    }
    
    private func createWeatherItems() -> [Item] {
        var items: [Item] = []
        if let dailyWeather = self.dailyWeather {
            for weather in dailyWeather.weather {
                let item = Item(with: weather)
                items.append(item)
            }
        }
        return items
    }
    
    private func createListItems() -> [Item] {
        var items: [Item] = []
        if let dailyWeather = self.dailyWeather {
            items.append(Item(image: UIImage(systemName: "thermometer"), title: "Max Daily Temperature:", description: dailyWeather.temp.max.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer"), title: "Min Daily Temperature:", description: dailyWeather.temp.min.temperatureString()))
            
            items.append(Item(image: UIImage(systemName: "thermometer.sun"), title: "Morning Temperatre:", description: dailyWeather.temp.morning.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer.sun"), title: "Day Temperatre:", description: dailyWeather.temp.day.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer.sun.fill"), title: "Evening Temperatre:", description: dailyWeather.temp.evening.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer.sun.fill"), title: "Night Temperatre:", description: dailyWeather.temp.night.temperatureString()))
            
            items.append(Item(image: UIImage(systemName: "thermometer.sun"), title: "Morning Feels Like Temperatre:", description: dailyWeather.feelsLikeTemp.morning.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer.sun"), title: "Day Feels Like Temperatre:", description: dailyWeather.feelsLikeTemp.day.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer.sun.fill"), title: "Evening Feels Like Temperatre:", description: dailyWeather.feelsLikeTemp.evening.temperatureString()))
            items.append(Item(image: UIImage(systemName: "thermometer.sun.fill"), title: "Night Feels Like Temperatre:", description: dailyWeather.feelsLikeTemp.night.temperatureString()))
            
            items.append(Item(image: UIImage(systemName: "sunrise"), title: "Sunrise:", description: dailyWeather.sunrise.timestampToDate().timeString()))
            items.append(Item(image: UIImage(systemName: "sunset.fill"), title: "Sunset:", description: dailyWeather.sunset.timestampToDate().timeString()))
            
            items.append(Item(image: UIImage(systemName: "moon.stars"), title: "Moonrise:", description: dailyWeather.moonrise.timestampToDate().timeString()))
            items.append(Item(image: UIImage(systemName: "moon.zzz.fill"), title: "Moonset:", description: dailyWeather.moonset.timestampToDate().timeString()))
            items.append(Item(image: nil, title: "Moon Phase:", description: dailyWeather.moonPhase.moonPhaseDescription()))
            
            items.append(Item(image: nil, title: "Atmospheric Pressure:", description: dailyWeather.pressure.pressureString()))
            items.append(Item(image: nil, title: "Humidity:", description: dailyWeather.humidity.percentString()))
            items.append(Item(image: nil, title: "Atmospheric temperature:", description: dailyWeather.dewPoint.temperatureString()))
            
            items.append(Item(image: UIImage(systemName: "wind"), title: "Wind Speed:", description: dailyWeather.windSpeed.speedString()))
            if let windGust = dailyWeather.windGust {
                items.append(Item(image: UIImage(systemName: "wind"), title: "Wind Gust:", description: windGust.speedString()))
            }
            items.append(Item(image: UIImage(systemName: "wind"), title: "Wind direction:", description: String(format: "%.1f°", dailyWeather.windDeg)))
            
            items.append(Item(image: UIImage(systemName: "cloud"), title: "Cloudness:", description: dailyWeather.clouds.percentString()))
            items.append(Item(image: UIImage(systemName: "rays"), title: "The maximum value of UV:", description: String(format: "%.1f", dailyWeather.uvi)))
            items.append(Item(image: UIImage(systemName: "cloud.rain"), title: "Probability of precipitation:", description: (dailyWeather.pop * 100).percentString()))
            
            if let rain = dailyWeather.rain {
                items.append(Item(image: UIImage(systemName: "cloud.rain"), title: "Precipitation Volume:", description: String(format: "%.1fmm", rain)))
            }
            if let snow = dailyWeather.snow {
                items.append(Item(image: UIImage(systemName: "cloud.snow"), title: "Snow Volume:", description: String(format: "%.1fmm", snow)))
            }
        }
        
        return items
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let provider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                return nil
            }
            
            switch sectionKind {
                case .weather:
                    return self.createWeathersLayout()
                case .list:
                    let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                    return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: provider)
        return layout
    }
    
    func createWeathersLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.valueCell()
            content.text = item.title
            content.image = item.image
            content.secondaryText = item.description
            cell.contentConfiguration = content
        }
    }
    
    func configureDataSource() {
        let listCellRegistration = self.createListCellRegistration()
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown Section")
            }
            switch section {
                case .weather:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
                    if let cell = cell as? WeatherCollectionViewCell, let weatherItem = item.weather {
                        cell.setup(with: weatherItem)
                    }
                    return cell
                case .list:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
                    return cell
            }
        })
        
        self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TextHeader", for: indexPath) as? TextHeaderCollectionReusableView
                switch Section.init(rawValue: indexPath.section) {
                    case .weather:
                        headerView?.titleLabel.text = "Current Overview"
                    default:
                        break
                }
                return headerView
            } else {
                return nil
            }
        }
    }
}
