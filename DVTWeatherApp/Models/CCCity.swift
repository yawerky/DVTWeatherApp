//
//  CCCity.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - City Model
struct CCCity: Codable {
    var m_id: Int
    var m_name: String
    var m_country: String
    var m_coordinate: CCCoordinate
    var m_population: Int
    var m_timezone: Int
    var m_sunrise: Int
    var m_sunset: Int

    enum CodingKeys: String, CodingKey {
        case m_id = "id"
        case m_name = "name"
        case m_country = "country"
        case m_coordinate = "coord"
        case m_population = "population"
        case m_timezone = "timezone"
        case m_sunrise = "sunrise"
        case m_sunset = "sunset"
    }

    // MARK: - Helpers

    /// Get sunrise time as Date
    func getSunriseDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(m_sunrise))
    }

    /// Get sunset time as Date
    func getSunsetDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(m_sunset))
    }

    /// Get formatted sunrise time
    func getFormattedSunrise() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: getSunriseDate())
    }

    /// Get formatted sunset time
    func getFormattedSunset() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: getSunsetDate())
    }
}
