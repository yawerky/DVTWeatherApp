//
//  CCWeatherViewModel.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation
import CoreLocation

protocol CCWeatherViewModelDelegate: AnyObject {
    func weatherDidUpdate()
    func weatherDidFailWithError(_ error: String)
}

class CCWeatherViewModel {

    private var m_forecastResponse: CCWeatherForecastResponse?
    private var m_isLoading: Bool = false
    private var m_networkManager: CCNetworkManager?
    weak var m_delegate: CCWeatherViewModelDelegate?

    var isLoading: Bool {
        return m_isLoading
    }

    var cityName: String {
        return m_forecastResponse?.getCityName() ?? "Unknown"
    }

    var locationDisplayName: String {
        return m_forecastResponse?.getLocationDisplayName() ?? "Unknown Location"
    }

    var currentTemperature: String {
        return m_forecastResponse?.getCurrentWeather()?.getTemperature() ?? "--°"
    }

    var currentWeatherDescription: String {
        return m_forecastResponse?.getCurrentWeather()?.getWeatherDescription() ?? "Loading..."
    }

    var currentWeatherCondition: String {
        guard let current = m_forecastResponse?.getCurrentWeather() else {
            return "Clear"
        }

        if current.isRaining() {
            return "Rain"
        } else if current.isCloudy() {
            return "Clouds"
        } else if current.isSunny() {
            return "Clear"
        }

        return "Clear"
    }

    var numberOfForecasts: Int {
        return m_forecastResponse?.getNext5DayForecasts().count ?? 0
    }

    func fetchWeatherForecast(for location: CLLocation) {
        m_isLoading = true
        let request = CCAPIGenerator.getForecast(location: location, units: .metric)
        m_networkManager = CCNetworkManager(httpRequest: request, delegate: self)
        m_networkManager?.startRequest()
    }

    func fetchWeatherForecast(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        fetchWeatherForecast(for: location)
    }

    func getForecastItem(at index: Int) -> CCWeatherForecastItem? {
        guard let forecasts = m_forecastResponse?.getNext5DayForecasts(),
              index >= 0,
              index < forecasts.count else {
            return nil
        }
        return forecasts[index]
    }

    func getAllForecasts() -> [CCWeatherForecastItem] {
        return m_forecastResponse?.getNext5DayForecasts() ?? []
    }

    func getDayName(at index: Int) -> String {
        return getForecastItem(at: index)?.getDayName() ?? "Unknown"
    }

    func getTemperature(at index: Int) -> String {
        return getForecastItem(at: index)?.getTemperature() ?? "--°"
    }

    func getWeatherDescription(at index: Int) -> String {
        return getForecastItem(at: index)?.getWeatherDescription() ?? "Unknown"
    }

    func getWeatherCondition(at index: Int) -> String {
        guard let forecast = getForecastItem(at: index) else {
            return "Clear"
        }

        if forecast.isRaining() {
            return "Rain"
        } else if forecast.isCloudy() {
            return "Clouds"
        } else if forecast.isSunny() {
            return "Clear"
        }

        return "Clear"
    }

    func getWeatherIconURL(at index: Int) -> URL? {
        return getForecastItem(at: index)?.getWeatherIconURL()
    }

    private func parseWeatherResponse(_ jsonData: Data) -> CCWeatherForecastResponse? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(CCWeatherForecastResponse.self, from: jsonData)
            return response
        } catch {
            return nil
        }
    }

    private func parseWeatherResponse(_ jsonDict: [String: Any]) -> CCWeatherForecastResponse? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            return parseWeatherResponse(jsonData)
        } catch {
            return nil
        }
    }

    func clearWeatherData() {
        m_forecastResponse = nil
    }

    func hasWeatherData() -> Bool {
        return m_forecastResponse != nil
    }
}

extension CCWeatherViewModel: CCNetworkDelegate {

    func onPreExecute(requestObject: CCHTTPRequest, forTaskCode taskCode: CCTaskCode) {
        m_isLoading = true
    }

    func onSuccess(
        _ response: CCHTTPResponse,
        forTaskCode taskCode: CCTaskCode,
        requestObject: CCHTTPRequest
    ) -> Bool {
        m_isLoading = false

        if let jsonDict = response.m_responseObject as? [String: Any] {
            if let forecastResponse = parseWeatherResponse(jsonDict) {
                m_forecastResponse = forecastResponse
                m_delegate?.weatherDidUpdate()
                return true
            }
        }

        m_delegate?.weatherDidFailWithError("Failed to parse weather data")
        return false
    }

    func onFailure(
        _ response: CCHTTPResponse,
        forTaskCode taskCode: CCTaskCode,
        requestObject: CCHTTPRequest
    ) {
        m_isLoading = false
        m_delegate?.weatherDidFailWithError(response.getErrorMessage())
    }
}

