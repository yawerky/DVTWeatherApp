//
//  CCRain.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Rain Model
struct CCRain: Codable {
    var m_threeHour: Double?

    enum CodingKeys: String, CodingKey {
        case m_threeHour = "3h"
    }

    // MARK: - Helpers

    /// Get formatted rain volume
    func getFormattedVolume() -> String {
        guard let volume = m_threeHour else { return "0 mm" }
        return String(format: "%.2f mm", volume)
    }
}
