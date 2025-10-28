//
//  CCSys.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Sys Model (Part of Day)
struct CCSys: Codable {
    var m_partOfDay: String

    enum CodingKeys: String, CodingKey {
        case m_partOfDay = "pod"
    }

    // MARK: - Helpers

    /// Check if it's day time
    func isDayTime() -> Bool {
        return m_partOfDay == "d"
    }

    /// Check if it's night time
    func isNightTime() -> Bool {
        return m_partOfDay == "n"
    }
}
