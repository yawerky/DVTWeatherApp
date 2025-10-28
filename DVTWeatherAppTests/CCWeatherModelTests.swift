//
//  CCWeatherModelTests.swift
//  DVTWeatherAppTests
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Testing
import Foundation
@testable import DVTWeatherApp

struct CCWeatherModelTests {

    // MARK: - CCWeatherForecastItem Tests

    @Test func testWeatherForecastItemGetDate() async throws {
        let timestamp = 1698422400 // Oct 27, 2023, 12:00:00 PM UTC
        let item = createMockForecastItem(timestamp: timestamp)

        let date = item.getDate()

        #expect(date.timeIntervalSince1970 == Double(timestamp))
    }

    @Test func testWeatherForecastItemGetDayName() async throws {
        let timestamp = 1730120400 // A specific timestamp for consistent testing
        let item = createMockForecastItem(timestamp: timestamp)

        let dayName = item.getDayName()

        // Day name should not be empty
        #expect(!dayName.isEmpty)
    }

    @Test func testWeatherForecastItemGetShortDayName() async throws {
        let timestamp = 1730120400
        let item = createMockForecastItem(timestamp: timestamp)

        let shortDayName = item.getShortDayName()

        // Short day name should be 3 characters (e.g., "Mon", "Tue")
        #expect(shortDayName.count == 3)
    }

    @Test func testWeatherForecastItemGetTime() async throws {
        let timestamp = 1730120400
        let item = createMockForecastItem(timestamp: timestamp)

        let time = item.getTime()

        // Time should be in HH:mm format
        #expect(time.contains(":"))
    }

    @Test func testWeatherForecastItemGetFormattedDate() async throws {
        let timestamp = 1730120400
        let item = createMockForecastItem(timestamp: timestamp)

        let formattedDate = item.getFormattedDate()

        // Formatted date should not be empty
        #expect(!formattedDate.isEmpty)
    }

    @Test func testWeatherForecastItemGetWeatherDescription() async throws {
        let weatherDetail = CCWeatherDetail(
            m_id: 800,
            m_main: "Clear",
            m_description: "clear sky",
            m_icon: "01d"
        )
        let item = createMockForecastItem(weather: [weatherDetail])

        let description = item.getWeatherDescription()

        #expect(description == "Clear Sky")
    }

    @Test func testWeatherForecastItemIsRaining() async throws {
        let rainyWeather = CCWeatherDetail(
            m_id: 500,
            m_main: "Rain",
            m_description: "light rain",
            m_icon: "10d"
        )
        let item = createMockForecastItem(weather: [rainyWeather])

        #expect(item.isRaining() == true)
        #expect(item.isCloudy() == false)
        #expect(item.isSunny() == false)
    }

    @Test func testWeatherForecastItemIsCloudy() async throws {
        let cloudyWeather = CCWeatherDetail(
            m_id: 802,
            m_main: "Clouds",
            m_description: "scattered clouds",
            m_icon: "03d"
        )
        let item = createMockForecastItem(weather: [cloudyWeather])

        #expect(item.isCloudy() == true)
        #expect(item.isRaining() == false)
        #expect(item.isSunny() == false)
    }

    @Test func testWeatherForecastItemIsSunny() async throws {
        let sunnyWeather = CCWeatherDetail(
            m_id: 800,
            m_main: "Clear",
            m_description: "clear sky",
            m_icon: "01d"
        )
        let item = createMockForecastItem(weather: [sunnyWeather])

        #expect(item.isSunny() == true)
        #expect(item.isRaining() == false)
        #expect(item.isCloudy() == false)
    }

    @Test func testWeatherForecastItemGetTemperature() async throws {
        let main = CCWeatherMain(
            m_temperature: 22.5,
            m_feelsLike: 21.0,
            m_tempMin: 20.0,
            m_tempMax: 25.0,
            m_pressure: 1013,
            m_seaLevel: 1013,
            m_groundLevel: 1010,
            m_humidity: 65,
            m_tempKf: 0.0
        )
        let item = createMockForecastItem(main: main)

        let temperature = item.getTemperature()

        // Should contain degree symbol
        #expect(temperature.contains("°"))
    }

    // MARK: - CCWeatherForecastResponse Tests

    @Test func testWeatherForecastResponseIsSuccess() async throws {
        let response = createMockResponse(code: "200")

        #expect(response.isSuccess() == true)
    }

    @Test func testWeatherForecastResponseIsNotSuccess() async throws {
        let response = createMockResponse(code: "404")

        #expect(response.isSuccess() == false)
    }

    @Test func testWeatherForecastResponseGetCityName() async throws {
        let city = CCCity(
            m_id: 1,
            m_name: "San Francisco",
            m_country: "US",
            m_coordinate: CCCoordinate(m_latitude: 37.7749, m_longitude: -122.4194),
            m_population: 883305,
            m_timezone: -25200,
            m_sunrise: 1698422400,
            m_sunset: 1698465600
        )
        let response = createMockResponse(city: city)

        #expect(response.getCityName() == "San Francisco")
    }

    @Test func testWeatherForecastResponseGetCountryName() async throws {
        let city = CCCity(
            m_id: 1,
            m_name: "San Francisco",
            m_country: "US",
            m_coordinate: CCCoordinate(m_latitude: 37.7749, m_longitude: -122.4194),
            m_population: 883305,
            m_timezone: -25200,
            m_sunrise: 1698422400,
            m_sunset: 1698465600
        )
        let response = createMockResponse(city: city)

        #expect(response.getCountryName() == "US")
    }

    @Test func testWeatherForecastResponseGetLocationDisplayName() async throws {
        let city = CCCity(
            m_id: 1,
            m_name: "San Francisco",
            m_country: "US",
            m_coordinate: CCCoordinate(m_latitude: 37.7749, m_longitude: -122.4194),
            m_population: 883305,
            m_timezone: -25200,
            m_sunrise: 1698422400,
            m_sunset: 1698465600
        )
        let response = createMockResponse(city: city)

        #expect(response.getLocationDisplayName() == "San Francisco, US")
    }

    @Test func testWeatherForecastResponseGetCurrentWeather() async throws {
        let forecasts = [createMockForecastItem(timestamp: 1730120400)]
        let response = createMockResponse(forecastList: forecasts)

        let currentWeather = response.getCurrentWeather()

        #expect(currentWeather != nil)
        #expect(currentWeather?.m_timestamp == 1730120400)
    }

    @Test func testWeatherForecastResponseGetNext5DayForecasts() async throws {
        // Create forecasts for different days
        let forecasts = [
            createMockForecastItem(timestamp: 1730120400), // Day 1
            createMockForecastItem(timestamp: 1730206800), // Day 2
            createMockForecastItem(timestamp: 1730293200), // Day 3
            createMockForecastItem(timestamp: 1730379600), // Day 4
            createMockForecastItem(timestamp: 1730466000), // Day 5
        ]
        let response = createMockResponse(forecastList: forecasts)

        let next5Days = response.getNext5DayForecasts()

        #expect(next5Days.count <= 5)
    }

    // MARK: - Helper Methods

    private func createMockForecastItem(
        timestamp: Int = 1730120400,
        main: CCWeatherMain? = nil,
        weather: [CCWeatherDetail]? = nil
    ) -> CCWeatherForecastItem {
        let defaultMain = main ?? CCWeatherMain(
            m_temperature: 20.0,
            m_feelsLike: 19.0,
            m_tempMin: 18.0,
            m_tempMax: 22.0,
            m_pressure: 1013,
            m_seaLevel: 1013,
            m_groundLevel: 1010,
            m_humidity: 65,
            m_tempKf: 0.0
        )

        let defaultWeather = weather ?? [
            CCWeatherDetail(
                m_id: 800,
                m_main: "Clear",
                m_description: "clear sky",
                m_icon: "01d"
            )
        ]

        return CCWeatherForecastItem(
            m_timestamp: timestamp,
            m_dateText: "2024-10-28 12:00:00",
            m_main: defaultMain,
            m_weather: defaultWeather,
            m_clouds: CCClouds(m_all: 0),
            m_wind: CCWind(m_speed: 5.0, m_degree: 180, m_gust: 7.0),
            m_visibility: 10000,
            m_probabilityOfPrecipitation: 0.0,
            m_sys: CCSys(m_partOfDay: "d"),
            m_rain: nil
        )
    }

    private func createMockResponse(
        code: String = "200",
        city: CCCity? = nil,
        forecastList: [CCWeatherForecastItem]? = nil
    ) -> CCWeatherForecastResponse {
        let defaultCity = city ?? CCCity(
            m_id: 1,
            m_name: "Test City",
            m_country: "TC",
            m_coordinate: CCCoordinate(m_latitude: 0.0, m_longitude: 0.0),
            m_population: 100000,
            m_timezone: 0,
            m_sunrise: 1698422400,
            m_sunset: 1698465600
        )

        let defaultForecasts = forecastList ?? []

        return CCWeatherForecastResponse(
            m_code: code,
            m_message: 0,
            m_count: defaultForecasts.count,
            m_forecastList: defaultForecasts,
            m_city: defaultCity
        )
    }
}
