//
//  CCWeatherJSONParsingTests.swift
//  DVTWeatherAppTests
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Testing
import Foundation
@testable import DVTWeatherApp

struct CCWeatherJSONParsingTests {

    // MARK: - CCWeatherDetail JSON Parsing

    @Test func testWeatherDetailJSONDecoding() async throws {
        let json = """
        {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let weatherDetail = try decoder.decode(CCWeatherDetail.self, from: data)

        #expect(weatherDetail.m_id == 800)
        #expect(weatherDetail.m_main == "Clear")
        #expect(weatherDetail.m_description == "clear sky")
        #expect(weatherDetail.m_icon == "01d")
    }

    @Test func testWeatherDetailGetCapitalizedDescription() async throws {
        let weatherDetail = CCWeatherDetail(
            m_id: 800,
            m_main: "Clear",
            m_description: "clear sky",
            m_icon: "01d"
        )

        #expect(weatherDetail.getCapitalizedDescription() == "Clear Sky")
    }

    @Test func testWeatherDetailGetIconURL() async throws {
        let weatherDetail = CCWeatherDetail(
            m_id: 800,
            m_main: "Clear",
            m_description: "clear sky",
            m_icon: "01d"
        )

        let iconURL = weatherDetail.getIconURL()

        #expect(iconURL != nil)
        #expect(iconURL?.absoluteString.contains("01d") == true)
    }

    @Test func testWeatherDetailIsRainy() async throws {
        let rainyWeather = CCWeatherDetail(
            m_id: 500,
            m_main: "Rain",
            m_description: "light rain",
            m_icon: "10d"
        )

        #expect(rainyWeather.isRainy() == true)
        #expect(rainyWeather.isCloudy() == false)
        #expect(rainyWeather.isSunny() == false)
    }

    @Test func testWeatherDetailIsCloudy() async throws {
        let cloudyWeather = CCWeatherDetail(
            m_id: 802,
            m_main: "Clouds",
            m_description: "scattered clouds",
            m_icon: "03d"
        )

        #expect(cloudyWeather.isCloudy() == true)
        #expect(cloudyWeather.isRainy() == false)
        #expect(cloudyWeather.isSunny() == false)
    }

    @Test func testWeatherDetailIsSunny() async throws {
        let sunnyWeather = CCWeatherDetail(
            m_id: 800,
            m_main: "Clear",
            m_description: "clear sky",
            m_icon: "01d"
        )

        #expect(sunnyWeather.isSunny() == true)
        #expect(sunnyWeather.isRainy() == false)
        #expect(sunnyWeather.isCloudy() == false)
    }

    // MARK: - CCWeatherMain JSON Parsing

    @Test func testWeatherMainJSONDecoding() async throws {
        let json = """
        {
            "temp": 22.5,
            "feels_like": 21.0,
            "temp_min": 20.0,
            "temp_max": 25.0,
            "pressure": 1013,
            "sea_level": 1013,
            "grnd_level": 1010,
            "humidity": 65,
            "temp_kf": 0.5
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let weatherMain = try decoder.decode(CCWeatherMain.self, from: data)

        #expect(weatherMain.m_temperature == 22.5)
        #expect(weatherMain.m_feelsLike == 21.0)
        #expect(weatherMain.m_tempMin == 20.0)
        #expect(weatherMain.m_tempMax == 25.0)
        #expect(weatherMain.m_pressure == 1013)
        #expect(weatherMain.m_humidity == 65)
    }

    @Test func testWeatherMainGetTemperatureCelsius() async throws {
        let weatherMain = CCWeatherMain(
            m_temperature: 22.7,
            m_feelsLike: 21.0,
            m_tempMin: 20.0,
            m_tempMax: 25.0,
            m_pressure: 1013,
            m_seaLevel: 1013,
            m_groundLevel: 1010,
            m_humidity: 65,
            m_tempKf: 0.0
        )

        // Should round down
        #expect(weatherMain.getTemperatureCelsius() == 22)
    }

    @Test func testWeatherMainGetFormattedTemperature() async throws {
        let weatherMain = CCWeatherMain(
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

        let formattedTemp = weatherMain.getFormattedTemperature()

        #expect(formattedTemp == "22°")
    }

    @Test func testWeatherMainNegativeTemperature() async throws {
        let weatherMain = CCWeatherMain(
            m_temperature: -5.3,
            m_feelsLike: -8.0,
            m_tempMin: -10.0,
            m_tempMax: -2.0,
            m_pressure: 1013,
            m_seaLevel: 1013,
            m_groundLevel: 1010,
            m_humidity: 80,
            m_tempKf: 0.0
        )

        #expect(weatherMain.getTemperatureCelsius() == -5)
        #expect(weatherMain.getFormattedTemperature() == "-5°")
    }

    // MARK: - CCWeatherForecastItem JSON Parsing

    @Test func testWeatherForecastItemJSONDecoding() async throws {
        let json = """
        {
            "dt": 1730120400,
            "dt_txt": "2024-10-28 12:00:00",
            "main": {
                "temp": 22.5,
                "feels_like": 21.0,
                "temp_min": 20.0,
                "temp_max": 25.0,
                "pressure": 1013,
                "sea_level": 1013,
                "grnd_level": 1010,
                "humidity": 65,
                "temp_kf": 0.5
            },
            "weather": [{
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01d"
            }],
            "clouds": {
                "all": 0
            },
            "wind": {
                "speed": 5.0,
                "deg": 180,
                "gust": 7.0
            },
            "visibility": 10000,
            "pop": 0.0,
            "sys": {
                "pod": "d"
            }
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let forecastItem = try decoder.decode(CCWeatherForecastItem.self, from: data)

        #expect(forecastItem.m_timestamp == 1730120400)
        #expect(forecastItem.m_dateText == "2024-10-28 12:00:00")
        #expect(forecastItem.m_main.m_temperature == 22.5)
        #expect(forecastItem.m_weather.count == 1)
        #expect(forecastItem.m_weather.first?.m_main == "Clear")
    }

    // MARK: - CCWeatherForecastResponse JSON Parsing

    @Test func testWeatherForecastResponseJSONDecoding() async throws {
        let json = """
        {
            "cod": "200",
            "message": 0,
            "cnt": 1,
            "list": [{
                "dt": 1730120400,
                "dt_txt": "2024-10-28 12:00:00",
                "main": {
                    "temp": 22.5,
                    "feels_like": 21.0,
                    "temp_min": 20.0,
                    "temp_max": 25.0,
                    "pressure": 1013,
                    "sea_level": 1013,
                    "grnd_level": 1010,
                    "humidity": 65,
                    "temp_kf": 0.5
                },
                "weather": [{
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01d"
                }],
                "clouds": {
                    "all": 0
                },
                "wind": {
                    "speed": 5.0,
                    "deg": 180,
                    "gust": 7.0
                },
                "visibility": 10000,
                "pop": 0.0,
                "sys": {
                    "pod": "d"
                }
            }],
            "city": {
                "id": 5391959,
                "name": "San Francisco",
                "coord": {
                    "lat": 37.7749,
                    "lon": -122.4194
                },
                "country": "US",
                "population": 883305,
                "timezone": -25200,
                "sunrise": 1730120400,
                "sunset": 1730163600
            }
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(CCWeatherForecastResponse.self, from: data)

        #expect(response.m_code == "200")
        #expect(response.m_count == 1)
        #expect(response.m_forecastList.count == 1)
        #expect(response.m_city.m_name == "San Francisco")
        #expect(response.isSuccess() == true)
    }

    @Test func testWeatherForecastResponseInvalidCode() async throws {
        let json = """
        {
            "cod": "404",
            "message": 0,
            "cnt": 0,
            "list": [],
            "city": {
                "id": 0,
                "name": "Unknown",
                "coord": {
                    "lat": 0.0,
                    "lon": 0.0
                },
                "country": "XX",
                "population": 0,
                "timezone": 0,
                "sunrise": 0,
                "sunset": 0
            }
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(CCWeatherForecastResponse.self, from: data)

        #expect(response.isSuccess() == false)
        #expect(response.m_code == "404")
    }
}
