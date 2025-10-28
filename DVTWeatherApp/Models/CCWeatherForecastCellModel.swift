//
//  CCWeatherForecastCellModel.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Weather Forecast Cell Model
class CCWeatherForecastCellModel: CCBaseTableCell {
    // MARK: - Properties
    var m_dayName: String
    var m_temperature: String
    var m_weatherDescription: String
    var m_weatherCondition: String  // "Rain", "Clouds", "Clear"

    // MARK: - Initialization

    /// Initialize with forecast data
    init(dayName: String, temperature: String, weatherDescription: String, weatherCondition: String) {
        self.m_dayName = dayName
        self.m_temperature = temperature
        self.m_weatherDescription = weatherDescription
        self.m_weatherCondition = weatherCondition
    }

    /// Initialize with forecast item
    convenience init(forecastItem: CCWeatherForecastItem) {
        let dayName = forecastItem.getDayName()
        let temperature = forecastItem.getTemperature()
        let weatherDescription = forecastItem.getWeatherDescription()

        var weatherCondition = "Clear"
        if forecastItem.isRaining() {
            weatherCondition = "Rain"
        } else if forecastItem.isCloudy() {
            weatherCondition = "Clouds"
        } else if forecastItem.isSunny() {
            weatherCondition = "Clear"
        }

        self.init(
            dayName: dayName,
            temperature: temperature,
            weatherDescription: weatherDescription,
            weatherCondition: weatherCondition
        )
    }

    // MARK: - CCBaseTableCell Protocol

    func getCellType() -> TableCellType {
        return .WEATHER_FORECAST
    }
}
