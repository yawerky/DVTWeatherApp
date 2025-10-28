//
//  CCWeatherEnums.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Weather Background
enum WeatherBackground: String {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case forest = "Forest"
}

// MARK: - Weather Icons
enum WeatherIcon: String {
    case sun = "01.sun-light"
    case partialCloudy = "05.partial-cloudy-light"
    case mostlyCloud = "07.mostly-cloud-light"
    case mostlyCloudy = "11.mostly-cloudy-light"
    case thunderstorm = "13.thunderstorm-light"
    case heavySnowfall = "14.heavy-snowfall-light"
    case cloud = "15.cloud-light"
    case heavyRain = "18.heavy-rain-light"
    case rain = "20.rain-light"
    case snow = "22.snow-light"
    case hailstorm = "23.hailstrom-light"
    case drop = "24.drop-light"
}
