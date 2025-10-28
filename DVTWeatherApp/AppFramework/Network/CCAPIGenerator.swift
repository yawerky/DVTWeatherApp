//
//  CCAPIGenerator.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT.
//

import Foundation
import CoreLocation

class CCAPIGenerator {

    static func getForecast(
        latitude: Double,
        longitude: Double,
        units: CCAPIConfig.Units = .metric
    ) -> CCHTTPRequest {
        let request = CCHTTPRequest()
        request.m_url = CCAPIConfig.m_baseURL_v25 + CCAPIConfig.Endpoint.m_forecast
        request.m_method = .get
        request.m_taskCode = .getForecast

        request.addParameter(CCAPIConfig.QueryParam.m_latitude, value: latitude)
        request.addParameter(CCAPIConfig.QueryParam.m_longitude, value: longitude)
        request.addParameter(CCAPIConfig.QueryParam.m_apiKey, value: CCAPIConfig.m_apiKey)
        request.addParameter(CCAPIConfig.QueryParam.m_units, value: units.rawValue)
        return request
    }

    static func getForecast(
        location: CLLocation,
        units: CCAPIConfig.Units = .metric
    ) -> CCHTTPRequest {
        getForecast(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            units: units
        )
    }


    static func getCurrentWeather(
        latitude: Double,
        longitude: Double,
        units: CCAPIConfig.Units = .metric
    ) -> CCHTTPRequest {
        let request = CCHTTPRequest()
        request.m_url = CCAPIConfig.m_baseURL_v25 + CCAPIConfig.Endpoint.m_weather
        request.m_method = .get
        request.m_taskCode = .getCurrentWeather

        request.addParameter(CCAPIConfig.QueryParam.m_latitude, value: latitude)
        request.addParameter(CCAPIConfig.QueryParam.m_longitude, value: longitude)
        request.addParameter(CCAPIConfig.QueryParam.m_apiKey, value: CCAPIConfig.m_apiKey)
        request.addParameter(CCAPIConfig.QueryParam.m_units, value: units.rawValue)
        return request
    }

    static func getCurrentWeather(
        location: CLLocation,
        units: CCAPIConfig.Units = .metric
    ) -> CCHTTPRequest {
        getCurrentWeather(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            units: units
        )
    }


    static func getWeatherByCity(
        cityName: String,
        units: CCAPIConfig.Units = .metric
    ) -> CCHTTPRequest {
        let request = CCHTTPRequest()
        request.m_url = CCAPIConfig.m_baseURL_v25 + CCAPIConfig.Endpoint.m_weather
        request.m_method = .get
        request.m_taskCode = .getCurrentWeather

        request.addParameter("q", value: cityName)
        request.addParameter(CCAPIConfig.QueryParam.m_apiKey, value: CCAPIConfig.m_apiKey)
        request.addParameter(CCAPIConfig.QueryParam.m_units, value: units.rawValue)
        return request
    }
}
