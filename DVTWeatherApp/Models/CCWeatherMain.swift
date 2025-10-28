//
//  CCWeatherMain.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Weather Main Data (Temperature, Pressure, Humidity)
struct CCWeatherMain: Codable {
    var m_temperature: Double
    var m_feelsLike: Double
    var m_tempMin: Double
    var m_tempMax: Double
    var m_pressure: Int
    var m_seaLevel: Int
    var m_groundLevel: Int
    var m_humidity: Int
    var m_tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case m_temperature = "temp"
        case m_feelsLike = "feels_like"
        case m_tempMin = "temp_min"
        case m_tempMax = "temp_max"
        case m_pressure = "pressure"
        case m_seaLevel = "sea_level"
        case m_groundLevel = "grnd_level"
        case m_humidity = "humidity"
        case m_tempKf = "temp_kf"
    }

    // MARK: - Helpers

    /// Get temperature in Celsius (rounded)
    func getTemperatureCelsius() -> Int {
        return Int(m_temperature)
    }

    /// Get feels like temperature (rounded)
    func getFeelsLikeCelsius() -> Int {
        return Int(m_feelsLike)
    }

    /// Get min temperature (rounded)
    func getMinTemperature() -> Int {
        return Int(m_tempMin)
    }

    /// Get max temperature (rounded)
    func getMaxTemperature() -> Int {
        return Int(m_tempMax)
    }

    /// Get formatted temperature with degree symbol
    func getFormattedTemperature() -> String {
        return "\(getTemperatureCelsius())°"
    }
}
