//
//  CCWeatherForecastItem.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Weather Forecast Item
struct CCWeatherForecastItem: Codable {
    var m_timestamp: Int
    var m_dateText: String
    var m_main: CCWeatherMain
    var m_weather: [CCWeatherDetail]
    var m_clouds: CCClouds
    var m_wind: CCWind
    var m_visibility: Int
    var m_probabilityOfPrecipitation: Double
    var m_sys: CCSys
    var m_rain: CCRain?

    enum CodingKeys: String, CodingKey {
        case m_timestamp = "dt"
        case m_dateText = "dt_txt"
        case m_main = "main"
        case m_weather = "weather"
        case m_clouds = "clouds"
        case m_wind = "wind"
        case m_visibility = "visibility"
        case m_probabilityOfPrecipitation = "pop"
        case m_sys = "sys"
        case m_rain = "rain"
    }

    // MARK: - Helpers

    /// Get date from timestamp
    func getDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(m_timestamp))
    }

    /// Get day name (e.g., "Monday")
    func getDayName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: getDate())
    }

    /// Get short day name (e.g., "Mon")
    func getShortDayName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: getDate())
    }

    /// Get time (e.g., "15:00")
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: getDate())
    }

    /// Get formatted date (e.g., "Oct 27, 2025")
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: getDate())
    }

    /// Get first weather detail
    func getFirstWeatherDetail() -> CCWeatherDetail? {
        return m_weather.first
    }

    /// Get weather description
    func getWeatherDescription() -> String {
        return getFirstWeatherDetail()?.getCapitalizedDescription() ?? "Unknown"
    }

    /// Get weather icon URL
    func getWeatherIconURL() -> URL? {
        return getFirstWeatherDetail()?.getIconURL()
    }

    /// Get temperature
    func getTemperature() -> String {
        return m_main.getFormattedTemperature()
    }

    /// Check if it's raining
    func isRaining() -> Bool {
        return getFirstWeatherDetail()?.isRainy() ?? false
    }

    /// Check if it's cloudy
    func isCloudy() -> Bool {
        return getFirstWeatherDetail()?.isCloudy() ?? false
    }

    /// Check if it's sunny
    func isSunny() -> Bool {
        return getFirstWeatherDetail()?.isSunny() ?? false
    }
}
