//
//  CCWeatherViewModelTests.swift
//  DVTWeatherAppTests
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Testing
import CoreLocation
@testable import DVTWeatherApp

struct CCWeatherViewModelTests {

    // MARK: - Initialization Tests

    @Test func testViewModelInitialization() async throws {
        let viewModel = CCWeatherViewModel()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.hasWeatherData() == false)
        #expect(viewModel.numberOfForecasts == 0)
    }

    @Test func testCityNameReturnsUnknownWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        #expect(viewModel.cityName == "Unknown")
        #expect(viewModel.locationDisplayName == "Unknown Location")
    }

    @Test func testCurrentTemperatureReturnsDefaultWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        #expect(viewModel.currentTemperature == "--°")
        #expect(viewModel.currentWeatherDescription == "Loading...")
    }

    @Test func testCurrentWeatherConditionReturnsDefaultWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        #expect(viewModel.currentWeatherCondition == "Clear")
    }

    // MARK: - Forecast Tests

    @Test func testGetForecastItemReturnsNilWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let forecast = viewModel.getForecastItem(at: 0)

        #expect(forecast == nil)
    }

    @Test func testGetForecastItemReturnsNilForInvalidIndex() async throws {
        let viewModel = CCWeatherViewModel()

        let negativeIndexForecast = viewModel.getForecastItem(at: -1)
        let largeIndexForecast = viewModel.getForecastItem(at: 100)

        #expect(negativeIndexForecast == nil)
        #expect(largeIndexForecast == nil)
    }

    @Test func testGetAllForecastsReturnsEmptyArrayWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let forecasts = viewModel.getAllForecasts()

        #expect(forecasts.isEmpty)
    }

    @Test func testGetDayNameReturnsUnknownWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let dayName = viewModel.getDayName(at: 0)

        #expect(dayName == "Unknown")
    }

    @Test func testGetTemperatureReturnsDefaultWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let temperature = viewModel.getTemperature(at: 0)

        #expect(temperature == "--°")
    }

    @Test func testGetWeatherDescriptionReturnsUnknownWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let description = viewModel.getWeatherDescription(at: 0)

        #expect(description == "Unknown")
    }

    @Test func testGetWeatherConditionReturnsDefaultWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let condition = viewModel.getWeatherCondition(at: 0)

        #expect(condition == "Clear")
    }

    @Test func testGetWeatherIconURLReturnsNilWhenNoData() async throws {
        let viewModel = CCWeatherViewModel()

        let iconURL = viewModel.getWeatherIconURL(at: 0)

        #expect(iconURL == nil)
    }

    // MARK: - Data Management Tests

    @Test func testClearWeatherDataRemovesData() async throws {
        let viewModel = CCWeatherViewModel()

        viewModel.clearWeatherData()

        #expect(viewModel.hasWeatherData() == false)
        #expect(viewModel.numberOfForecasts == 0)
    }

    @Test func testFetchWeatherForecastWithCoordinates() async throws {
        let viewModel = CCWeatherViewModel()

        // Test that method doesn't crash with valid coordinates
        viewModel.fetchWeatherForecast(latitude: 37.7749, longitude: -122.4194)

        // No assertion needed - just verifying no crash
    }
}
