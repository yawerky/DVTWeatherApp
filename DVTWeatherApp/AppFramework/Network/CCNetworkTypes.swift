//
//  CCNetworkTypes.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

@objc enum CCHTTPMethod: Int {
    case get
    case post
    case put
    case delete
    case patch

    var stringValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        }
    }
}

@objc enum CCTaskCode: Int {
    case getForecast
    case getCurrentWeather
    case getWeatherByLocation

    var description: String {
        switch self {
        case .getForecast: return "Get 5-Day Forecast"
        case .getCurrentWeather: return "Get Current Weather"
        case .getWeatherByLocation: return "Get Weather by Location"
        }
    }
}

enum CCHTTPResponseResult {
    case success
    case failure
}

class CCHTTPRequest {

    var m_url: String = ""
    var m_method: CCHTTPMethod = .get
    var m_taskCode: CCTaskCode = .getForecast
    var m_parameters: [String: Any] = [:]
    var m_headers: [String: String] = [:]
    var m_timeoutInterval: TimeInterval = CCAPIConfig.Timeout.m_request

    init() {
        addDefaultHeaders()
    }

    private func addDefaultHeaders() {
        m_headers["Content-Type"] = "application/json"
        m_headers["Accept"] = "application/json"
    }

    func addParameter(_ key: String, value: Any) {
        m_parameters[key] = value
    }

    func addHeader(_ key: String, value: String) {
        m_headers[key] = value
    }

    func buildURL() -> String {
        guard m_method == .get, !m_parameters.isEmpty else {
            return m_url
        }

        var components = URLComponents(string: m_url)
        var queryItems: [URLQueryItem] = []

        for (key, value) in m_parameters {
            let stringValue = "\(value)"
            queryItems.append(URLQueryItem(name: key, value: stringValue))
        }

        components?.queryItems = queryItems
        return components?.url?.absoluteString ?? m_url
    }

    func getJSONBody() -> Data? {
        guard m_method != .get, !m_parameters.isEmpty else {
            return nil
        }

        do {
            return try JSONSerialization.data(withJSONObject: m_parameters, options: [])
        } catch {
            return nil
        }
    }

    func buildURLRequest() -> URLRequest? {
        let urlString = buildURL()

        guard let url = URL(string: urlString) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = m_method.stringValue
        request.timeoutInterval = m_timeoutInterval

        for (key, value) in m_headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if m_method != .get {
            request.httpBody = getJSONBody()
        }

        return request
    }

}

class CCHTTPResponse {

    var m_result: CCHTTPResponseResult = .failure
    var m_responseObject: Any?
    var m_statusCode: Int?
    var m_error: Error?
    var m_rawData: Data?
    var m_rawString: String?

    init() {}

    init(result: CCHTTPResponseResult, responseObject: Any? = nil, error: Error? = nil) {
        self.m_result = result
        self.m_responseObject = responseObject
        self.m_error = error
    }

    func isSuccess() -> Bool {
        return m_result == .success
    }

    func getErrorMessage() -> String {
        if let error = m_error {
            return error.localizedDescription
        }

        if let baseResponse = m_responseObject as? CCBaseResponse {
            return baseResponse.friendlyMessage
        }

        return "An unexpected error occurred"
    }

    func getResponse<T>() -> T? {
        return m_responseObject as? T
    }
}

protocol CCNetworkDelegate: AnyObject {
    func onPreExecute(requestObject: CCHTTPRequest, forTaskCode taskCode: CCTaskCode)
    func onSuccess(_ response: CCHTTPResponse, forTaskCode taskCode: CCTaskCode, requestObject: CCHTTPRequest) -> Bool
    func onFailure(_ response: CCHTTPResponse, forTaskCode taskCode: CCTaskCode, requestObject: CCHTTPRequest)
}

extension CCNetworkDelegate {
    func onPreExecute(requestObject: CCHTTPRequest, forTaskCode taskCode: CCTaskCode) {}
}
