//
//  CCWeatherEnumsTests.swift
//  DVTWeatherAppTests
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Testing
import Foundation
@testable import DVTWeatherApp

struct CCWeatherEnumsTests {

    // MARK: - WeatherBackground Tests

    @Test func testWeatherBackgroundRawValues() async throws {
        #expect(WeatherBackground.sunny.rawValue == "Sunny")
        #expect(WeatherBackground.cloudy.rawValue == "Cloudy")
        #expect(WeatherBackground.rainy.rawValue == "Rainy")
        #expect(WeatherBackground.forest.rawValue == "Forest")
    }

    @Test func testWeatherBackgroundInitFromRawValue() async throws {
        #expect(WeatherBackground(rawValue: "Sunny") == .sunny)
        #expect(WeatherBackground(rawValue: "Cloudy") == .cloudy)
        #expect(WeatherBackground(rawValue: "Rainy") == .rainy)
        #expect(WeatherBackground(rawValue: "Forest") == .forest)
    }

    @Test func testWeatherBackgroundInvalidRawValue() async throws {
        let invalid = WeatherBackground(rawValue: "InvalidWeather")
        #expect(invalid == nil)
    }

    @Test func testWeatherBackgroundAllCases() async throws {
        let allCases: [WeatherBackground] = [.sunny, .cloudy, .rainy, .forest]
        #expect(allCases.count == 4)
    }

    // MARK: - WeatherIcon Tests

    @Test func testWeatherIconRawValues() async throws {
        #expect(WeatherIcon.sun.rawValue == "01.sun-light")
        #expect(WeatherIcon.partialCloudy.rawValue == "05.partial-cloudy-light")
        #expect(WeatherIcon.mostlyCloud.rawValue == "07.mostly-cloud-light")
        #expect(WeatherIcon.mostlyCloudy.rawValue == "11.mostly-cloudy-light")
        #expect(WeatherIcon.thunderstorm.rawValue == "13.thunderstorm-light")
        #expect(WeatherIcon.heavySnowfall.rawValue == "14.heavy-snowfall-light")
        #expect(WeatherIcon.cloud.rawValue == "15.cloud-light")
        #expect(WeatherIcon.heavyRain.rawValue == "18.heavy-rain-light")
        #expect(WeatherIcon.rain.rawValue == "20.rain-light")
        #expect(WeatherIcon.snow.rawValue == "22.snow-light")
        #expect(WeatherIcon.hailstorm.rawValue == "23.hailstrom-light")
        #expect(WeatherIcon.drop.rawValue == "24.drop-light")
    }

    @Test func testWeatherIconInitFromRawValue() async throws {
        #expect(WeatherIcon(rawValue: "01.sun-light") == .sun)
        #expect(WeatherIcon(rawValue: "15.cloud-light") == .cloud)
        #expect(WeatherIcon(rawValue: "20.rain-light") == .rain)
        #expect(WeatherIcon(rawValue: "22.snow-light") == .snow)
    }

    @Test func testWeatherIconInvalidRawValue() async throws {
        let invalid = WeatherIcon(rawValue: "99.invalid-icon")
        #expect(invalid == nil)
    }

    @Test func testWeatherIconAllCases() async throws {
        let allCases: [WeatherIcon] = [
            .sun, .partialCloudy, .mostlyCloud, .mostlyCloudy,
            .thunderstorm, .heavySnowfall, .cloud, .heavyRain,
            .rain, .snow, .hailstorm, .drop
        ]
        #expect(allCases.count == 12)
    }

    @Test func testWeatherIconNamesAreUnique() async throws {
        let allIcons: [WeatherIcon] = [
            .sun, .partialCloudy, .mostlyCloud, .mostlyCloudy,
            .thunderstorm, .heavySnowfall, .cloud, .heavyRain,
            .rain, .snow, .hailstorm, .drop
        ]

        let rawValues = allIcons.map { $0.rawValue }
        let uniqueValues = Set(rawValues)

        // All raw values should be unique
        #expect(rawValues.count == uniqueValues.count)
    }

    @Test func testWeatherBackgroundNamesAreUnique() async throws {
        let allBackgrounds: [WeatherBackground] = [.sunny, .cloudy, .rainy, .forest]

        let rawValues = allBackgrounds.map { $0.rawValue }
        let uniqueValues = Set(rawValues)

        // All raw values should be unique
        #expect(rawValues.count == uniqueValues.count)
    }
}
