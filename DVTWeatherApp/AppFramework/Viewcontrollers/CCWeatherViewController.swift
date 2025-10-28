//
//  ViewController.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Weather View Controller
class CCWeatherViewController: CCBaseTableVC {

    // MARK: - Properties
    private var m_locationManager: CLLocationManager!
    private var m_currentLocation: CLLocation?
    private var m_viewModel: CCWeatherViewModel!

    @IBOutlet weak var m_tableview: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        setupLocationManager()
    }

    override func setupUI() {
        super.setupUI()
        // Use adaptive system colors for dark mode support
        view.backgroundColor = .systemGroupedBackground
        title = "Weather Forecast"

        // Configure navigation bar for dark mode
        configureNavigationBarAppearance()
    }

    private func configureNavigationBarAppearance() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        // Use adaptive colors that work in both light and dark mode
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }

    override func getTableView() -> UITableView? {
        return m_tableview
    }

    // MARK: - Table View Setup

    private func setupTableView() {
        guard let tableView = m_tableview else { return }

        // Configure table view appearance for dark mode support
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .separator  // Adaptive separator color
        tableView.backgroundColor = .clear  // Clear background - only cells have background
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120

        // No need to register cells or set data source/delegate
        // CCBaseTableVC handles this automatically (beatroute pattern)
    }

    // MARK: - Setup

    private func setupViewModel() {
        m_viewModel = CCWeatherViewModel()
        m_viewModel.m_delegate = self
    }

    private func setupLocationManager() {
        m_locationManager = CLLocationManager()
        m_locationManager.delegate = self
        m_locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Request location permission
        requestLocationPermission(m_locationManager)
    }

    // MARK: - API Calls

    private func fetchWeatherForecast() {
        guard let location = m_currentLocation else {
            showError(message: "Location not available")
            return
        }

        // Check if API key is configured
        guard CCAPIGenerator.isAPIKeyConfigured() else {
            showError(message: CCAPIGenerator.getAPIKeyErrorMessage())
            return
        }

        print("📡 Fetching weather for location: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        // Use ViewModel to fetch weather (MVVM Pattern)
        m_viewModel.fetchWeatherForecast(for: location)
    }

    // MARK: - Table View Override (Beatroute Pattern)

    override func onCellSelected(at indexPath: IndexPath) {
        // Show detailed weather info when cell is tapped
        let dayName = m_viewModel.getDayName(at: indexPath.row)
        let temperature = m_viewModel.getTemperature(at: indexPath.row)
        let weatherDescription = m_viewModel.getWeatherDescription(at: indexPath.row)

        showAlert(
            title: dayName,
            message: "\(temperature)\n\(weatherDescription)"
        )
    }
}

// MARK: - Weather ViewModel Delegate
extension CCWeatherViewController: CCWeatherViewModelDelegate {

    func weatherDidUpdate() {
        print("✅ Weather data updated successfully!")
        print("📍 Location: \(m_viewModel.locationDisplayName)")
        print("🌡️ Temperature: \(m_viewModel.currentTemperature)")
        print("☁️ Condition: \(m_viewModel.currentWeatherDescription)")
        print("📊 Forecast items: \(m_viewModel.numberOfForecasts)")

        // Print 5-day forecast
        print("\n📅 5-Day Forecast:")
        for index in 0..<m_viewModel.numberOfForecasts {
            let day = m_viewModel.getDayName(at: index)
            let temp = m_viewModel.getTemperature(at: index)
            let desc = m_viewModel.getWeatherDescription(at: index)
            print("   \(day): \(temp) - \(desc)")
        }

        // Populate list array (beatroute pattern)
        populateWeatherList()

        // Reload table view to display forecast
        refreshTable()

        // Show success alert
        showAlert(
            title: "Weather Updated",
            message: "\(m_viewModel.locationDisplayName)\n\(m_viewModel.currentTemperature) - \(m_viewModel.currentWeatherDescription)"
        )
    }

    // MARK: - Data Population

    private func populateWeatherList() {
        // Clear existing list
        list.removeAll()

        // Add forecast items to list (beatroute pattern)
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
        print("❌ Weather fetch failed: \(error)")
        showError(message: error)
    }
}

// MARK: - Location Delegate
extension CCWeatherViewController {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        print("📍 Location acquired: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        m_currentLocation = location

        // Stop updating location
        m_locationManager.stopUpdatingLocation()

        // Fetch weather
        fetchWeatherForecast()
    }

    override func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
        showError(message: "Unable to get your location. Please try again.")
    }
}
