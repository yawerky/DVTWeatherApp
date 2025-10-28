//
//  ViewController.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import UIKit
import CoreLocation

class CCWeatherViewController: CCBaseTableVC {
    private var m_locationManager: CLLocationManager!
    private var m_currentLocation: CLLocation?
    private var m_viewModel: CCWeatherViewModel!

    @IBOutlet weak var m_tableview: UITableView!
    @IBOutlet weak var m_bg_imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        setupLocationManager()
    }

    override func setupUI() {
        super.setupUI()
        setupToolbar()
    }
    
    private func setupToolbar(){
        let toolbar = addToolbar(title: "5 Day Forecast")
        toolbar.showBackButton()
        toolbar.showRightButton(systemName: "gear")
        toolbar.delegate = self
    }

    override func getTableView() -> UITableView? {
        return m_tableview
    }

    private func setupTableView() {
        guard let tableView = m_tableview else { return }
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .separator
        tableView.backgroundColor = .clear
    }

    private func setupViewModel() {
        m_viewModel = CCWeatherViewModel()
        m_viewModel.m_delegate = self
    }

    private func setupLocationManager() {
        m_locationManager = CLLocationManager()
        m_locationManager.delegate = self
        m_locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission(m_locationManager)
    }
    
    private func updateBackgroundImage(for condition: String) {
        let imageName: String

        switch condition.lowercased() {
        case "clear":
            imageName = WeatherBackground.sunny.rawValue
        case "clouds":
            imageName = WeatherBackground.cloudy.rawValue
        case "rain", "drizzle":
            imageName = WeatherBackground.rainy.rawValue
        case "snow", "mist", "fog", "haze":
            imageName = WeatherBackground.forest.rawValue
        default:
            imageName = WeatherBackground.sunny.rawValue
        }

        DispatchQueue.main.async { [weak self] in
            UIView.transition(
                with: self?.m_bg_imageView ?? UIImageView(),
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    self?.m_bg_imageView.image = UIImage(named: imageName)
                },
                completion: nil
            )

            self?.m_bg_imageView.contentMode = .scaleAspectFill
            self?.m_bg_imageView.clipsToBounds = true
        }
    }

    private func fetchWeatherForecast() {
        guard let location = m_currentLocation else {
            showError(message: "Location not available")
            return
        }
        m_viewModel.fetchWeatherForecast(for: location)
    }

    override func onCellSelected(at indexPath: IndexPath) {
        let dayName = m_viewModel.getDayName(at: indexPath.row)
        let temperature = m_viewModel.getTemperature(at: indexPath.row)
        let weatherDescription = m_viewModel.getWeatherDescription(at: indexPath.row)
        showAlert(
            title: dayName,
            message: "\(temperature)\n\(weatherDescription)"
        )
    }
}

extension CCWeatherViewController: CCWeatherViewModelDelegate {

    func weatherDidUpdate() {

        updateBackgroundImage(for: m_viewModel.currentWeatherCondition)

        populateWeatherList()

        refreshTable()

        showAlert(
            title: "Weather Updated",
            message: "\(m_viewModel.locationDisplayName)\n\(m_viewModel.currentTemperature) - \(m_viewModel.currentWeatherDescription)"
        )
    }

    private func populateWeatherList() {
        list.removeAll()
        for index in 0..<m_viewModel.numberOfForecasts {
            let dayName = m_viewModel.getDayName(at: index)
            let temperature = m_viewModel.getTemperature(at: index)
            let weatherDescription = m_viewModel.getWeatherDescription(at: index)
            let weatherCondition = m_viewModel.getWeatherCondition(at: index)
            let cellModel = CCWeatherForecastCellModel(
                dayName: dayName,
                temperature: temperature,
                weatherDescription: weatherDescription,
                weatherCondition: weatherCondition
            )
            list.append(cellModel)
        }
    }

    func weatherDidFailWithError(_ error: String) {
        showError(message: error)
    }
}

extension CCWeatherViewController {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        m_currentLocation = location
        m_locationManager.stopUpdatingLocation()
        fetchWeatherForecast()
    }

    override func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showError(message: "Unable to get your location. Please try again.")
    }
}

extension CCWeatherViewController: CCToolbarDelegate {
     func toolbarBackButtonTapped() {
         // Go back
     }

     func toolbarRightButtonTapped() {
         // Not implemented yet
     }
 }
