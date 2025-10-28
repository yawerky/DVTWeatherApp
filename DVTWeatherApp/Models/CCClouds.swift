//
//  CCClouds.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Clouds Model
struct CCClouds: Codable {
    var m_all: Int

    enum CodingKeys: String, CodingKey {
        case m_all = "all"
    }
}
