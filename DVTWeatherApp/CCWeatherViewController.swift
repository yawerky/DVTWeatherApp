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
class CCWeatherViewController: CCBaseVC {

    // MARK: - Properties
    private var m_locationManager: CLLocationManager!
    private var m_currentLocation: CLLocation?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }

    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .systemBackground
        title = "Weather"
    }

    // MARK: - Location Setup

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

        // Generate request
        let request = CCAPIGenerator.getForecast(location: location, units: .metric)

        // Call API
        downloadData(httpRequest: request)
    }

    // MARK: - API Response Handling

    override func onAPISuccess(response: CCHTTPResponse, taskCode: CCTaskCode) -> Bool {
        switch taskCode {
        case .getForecast:
            handleForecastResponse(response)
            return true

        default:
            return super.onAPISuccess(response: response, taskCode: taskCode)
        }
    }

    private func handleForecastResponse(_ response: CCHTTPResponse) {
        guard let jsonDict = response.m_responseObject as? [String: Any] else {
            showError(message: "Invalid response format")
            return
        }

        print("✅ Weather Data Received:")
        print(jsonDict)

        // Parse forecast list
        if let list = jsonDict["list"] as? [[String: Any]] {
            print("\n📊 Forecast Items: \(list.count)")

            // Print first 5 items
            for (index, item) in list.prefix(5).enumerated() {
                if let main = item["main"] as? [String: Any],
                   let temp = main["temp"] as? Double,
                   let weather = item["weather"] as? [[String: Any]],
                   let weatherDesc = weather.first?["description"] as? String,
                   let dateString = item["dt_txt"] as? String {

                    print("\n🌤 Day \(index + 1):")
                    print("   Date: \(dateString)")
                    print("   Temp: \(Int(temp))°C")
                    print("   Weather: \(weatherDesc)")
                }
            }

            // TODO: Update UI with weather data
            showAlert(title: "Success", message: "Weather data loaded successfully! Check console for details.")
        }
    }

    override func onAPIFailure(response: CCHTTPResponse, taskCode: CCTaskCode) {
        super.onAPIFailure(response: response, taskCode: taskCode)
        print("❌ API Failed for: \(taskCode.description)")
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
