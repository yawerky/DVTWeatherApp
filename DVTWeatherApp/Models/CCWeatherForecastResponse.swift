//
//  CCWeatherForecastResponse.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

// MARK: - Weather Forecast Response
struct CCWeatherForecastResponse: Codable {
    var m_code: String
    var m_message: Int
    var m_count: Int
    var m_forecastList: [CCWeatherForecastItem]
    var m_city: CCCity

    enum CodingKeys: String, CodingKey {
        case m_code = "cod"
        case m_message = "message"
        case m_count = "cnt"
        case m_forecastList = "list"
        case m_city = "city"
    }

    // MARK: - Helpers

    /// Check if response is successful
    func isSuccess() -> Bool {
        return m_code == "200"
    }

    /// Get current weather (first item in list)
    func getCurrentWeather() -> CCWeatherForecastItem? {
        return m_forecastList.first
    }

    /// Get forecasts grouped by day (one forecast per day)
    func getForecastsByDay(limit: Int = 5) -> [CCWeatherForecastItem] {
        var dailyForecasts: [CCWeatherForecastItem] = []
        var processedDays: Set<String> = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for forecast in m_forecastList {
            let date = forecast.getDate()
            let dayString = dateFormatter.string(from: date)

            // Check if we already have a forecast for this day
            if !processedDays.contains(dayString) {
                dailyForecasts.append(forecast)
                processedDays.insert(dayString)

                // Stop if we reached the limit
                if dailyForecasts.count >= limit {
                    break
                }
            }
        }

        return dailyForecasts
    }

    /// Get forecasts for next 5 days (noon time preferred)
    func getNext5DayForecasts() -> [CCWeatherForecastItem] {
        var dailyForecasts: [String: [CCWeatherForecastItem]] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Group forecasts by day
        for forecast in m_forecastList {
            let date = forecast.getDate()
            let dayString = dateFormatter.string(from: date)

            if dailyForecasts[dayString] == nil {
                dailyForecasts[dayString] = []
            }
            dailyForecasts[dayString]?.append(forecast)
        }

        // Get one forecast per day (prefer noon/afternoon time)
        var result: [CCWeatherForecastItem] = []
        let sortedDays = dailyForecasts.keys.sorted()

        for day in sortedDays.prefix(5) {
            guard let forecastsForDay = dailyForecasts[day] else { continue }

            // Try to find noon or afternoon forecast
            if let noonForecast = forecastsForDay.first(where: {
                let time = $0.getTime()
                return time.contains("12:00") || time.contains("15:00") || time.contains("18:00")
            }) {
                result.append(noonForecast)
            } else if let firstForecast = forecastsForDay.first {
                // Fallback to first available forecast for the day
                result.append(firstForecast)
            }
        }

        return result
    }

    /// Get city name
    func getCityName() -> String {
        return m_city.m_name
    }

    /// Get country name
    func getCountryName() -> String {
        return m_city.m_country
    }

    /// Get location display name
    func getLocationDisplayName() -> String {
        return "\(m_city.m_name), \(m_city.m_country)"
    }
}
