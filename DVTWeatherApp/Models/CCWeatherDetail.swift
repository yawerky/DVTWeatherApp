//
//  CCWeatherDetail.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Weather Detail (Description, Icon)
struct CCWeatherDetail: Codable {
    var m_id: Int
    var m_main: String
    var m_description: String
    var m_icon: String

    enum CodingKeys: String, CodingKey {
        case m_id = "id"
        case m_main = "main"
        case m_description = "description"
        case m_icon = "icon"
    }

    // MARK: - Helpers

    /// Get capitalized description
    func getCapitalizedDescription() -> String {
        return m_description.capitalized
    }

    /// Get weather icon URL
    func getIconURL() -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(m_icon)@2x.png")
    }

    /// Check if weather is rainy
    func isRainy() -> Bool {
        return m_main.lowercased().contains("rain")
    }

    /// Check if weather is cloudy
    func isCloudy() -> Bool {
        return m_main.lowercased().contains("cloud")
    }

    /// Check if weather is clear/sunny
    func isSunny() -> Bool {
        return m_main.lowercased().contains("clear")
    }
}
