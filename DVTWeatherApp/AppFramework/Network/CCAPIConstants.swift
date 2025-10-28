//
// CCAPIConstants.swift
// DVTWeatherApp
//
// Created by Yawer Khan on 26/10/25.
// Copyright © 2025 DVT. All rights reserved.
//

import Foundation

struct CCAPIConfig {

    static let m_baseURL_v25 = "https://api.openweathermap.org/data/2.5/"
    static let m_baseURL_v30 = "https://api.openweathermap.org/data/3.0/"

    static let m_apiKey = "0acfbfa67afd4e945cd14c199e555c0c"

    struct Endpoint {
        static let m_forecast = "forecast"
        static let m_weather = "weather"
        static let m_onecall = "onecall"
    }

    struct QueryParam {
        static let m_latitude = "lat"
        static let m_longitude = "lon"
        static let m_apiKey = "appid"
        static let m_units = "units"
        static let m_count = "cnt"
        static let m_exclude = "exclude"
    }

    enum Units: String {
        case metric = "metric"
        case imperial = "imperial"
        case standard = "standard"
    }

    struct Timeout {
        static let m_request: TimeInterval = 30.0
        static let m_resource: TimeInterval = 60.0
    }
}
