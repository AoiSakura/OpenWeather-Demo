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
    enum Section: Int, Hashable, CaseIterable {
        case overview, daily
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private lazy var weatherService = OpenWeatherService()
    private var hud: MBProgressHUD?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, NSObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupLocationManager()
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getCurrentLocation()
    }

    @IBAction func userTouchedRequestLocationButton(_ sender: Any) {
        self.getCurrentLocation()
    }
    
    func configureUI() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        self.collectionView.collectionViewLayout = self.createCollectionViewLayout()
        self.configureDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue", let destinationVC = segue.destination as? DetailWeatherViewController, let dailyWeather = sender as? DailyWeatherInfo {
            destinationVC.dailyWeather = dailyWeather
        }
    }
    
    func showHud() {
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud?.isSquare = true
        self.hud?.removeFromSuperViewOnHide = false
        self.hud?.label.textColor = .white
        self.hud?.bezelView.color = UIColor(white: 0, alpha: 0.7)
        self.hud?.bezelView.layer.cornerRadius = 20
    }
}

extension WeatherListViewController {
    func setupLocationManager() {
        self.locationManager.delegate = self
        let authorizationStatus = self.locationManager.authorizationStatus
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            self.getCurrentLocation()
        }
    }
    
    func getCurrentLocation() {
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestLocation()
        }
    }
    
    @objc func fetchWeatherData() {
        if let location = self.currentLocation, self.hud == nil {
            self.showHud()
            
            self.weatherService.getWeatherRequest(for: location) { [weak self] isSuccess, weatherInfo, error in
                if self?.collectionView.refreshControl?.isRefreshing == true {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
                if let hud = self?.hud {
                    hud.hide(animated: true)
                    self?.hud = nil
                }
                if isSuccess, let weatherInfo = weatherInfo {
                    self?.applySnapshots(with: weatherInfo)
                }
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

extension WeatherListViewController {
    func applySnapshots(with locationWeather: LocationWeatherInfo) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NSObject>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([locationWeather], toSection: .overview)
        snapshot.appendItems(locationWeather.daily, toSection: .daily)
        
        self.dataSource.apply(snapshot)
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let provider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 20
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: provider)
        return layout
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, NSObject>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown Section")
            }
            switch section {
                case .overview:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverviewCell", for: indexPath)
                    if let cell = cell as? OverviewCollectionViewCell, let overviewItem = item as? LocationWeatherInfo {
                        cell.setupCell(with: overviewItem)
                    }
                    return cell
                case .daily:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath)
                    if let cell = cell as? DailyWeatherCollectionViewCell, let dailyItem = item as? DailyWeatherInfo {
                        cell.setup(with: dailyItem)
                    }
                    return cell
            }
        })
        
        self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TextHeader", for: indexPath) as? TextHeaderCollectionReusableView
                switch Section.init(rawValue: indexPath.section) {
                    case .overview:
                        headerView?.titleLabel.text = "Current Overview"
                    case .daily:
                        headerView?.titleLabel.text = "Daily"
                    case .none:
                        break
                }
                return headerView
            } else {
                return nil
            }
        }
    }
}

extension WeatherListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
            case .overview:
                return
            case .daily:
                let dailyWeahters = self.dataSource.snapshot().itemIdentifiers(inSection: .daily)
                let selectedDailyWeather = dailyWeahters[indexPath.row]
                self.performSegue(withIdentifier: "showDetailSegue", sender: selectedDailyWeather)
        }
    }
}
