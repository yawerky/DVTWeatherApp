//
//  CCCoordinate.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Coordinate Model
struct CCCoordinate: Codable {
    var m_latitude: Double
    var m_longitude: Double

    enum CodingKeys: String, CodingKey {
        case m_latitude = "lat"
        case m_longitude = "lon"
    }
}
