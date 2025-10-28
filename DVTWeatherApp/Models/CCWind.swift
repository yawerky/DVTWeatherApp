//
//  CCWind.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Wind Model
struct CCWind: Codable {
    var m_speed: Double
    var m_degree: Int
    var m_gust: Double?

    enum CodingKeys: String, CodingKey {
        case m_speed = "speed"
        case m_degree = "deg"
        case m_gust = "gust"
    }

    // MARK: - Helpers

    func getSpeedKmh() -> Double {
        return m_speed * 3.6
    }

    func getFormattedSpeed() -> String {
        return String(format: "%.1f km/h", getSpeedKmh())
    }
}
