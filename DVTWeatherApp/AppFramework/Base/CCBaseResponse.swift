//
//  CCBaseResponse.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation

protocol CCBaseResponseRepresentable {
    var isSuccessful: Bool { get }
    var message: String? { get }
}

class CCBaseResponse: Decodable, CCBaseResponseRepresentable {

    var isSuccessful: Bool = false
    var message: String?
    var httpStatusCode: Int?

    private enum CodingKeys: String, CodingKey {
        case isSuccessful = "success"
        case message
        case httpStatusCode = "cod"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let successFlag = try? container.decode(Bool.self, forKey: .isSuccessful) {
            isSuccessful = successFlag
        }

        httpStatusCode = try? container.decode(Int.self, forKey: .httpStatusCode)

        if let code = httpStatusCode {
            isSuccessful = (code == 200)
        }

        message = try? container.decode(String.self, forKey: .message)
    }

    init() {}

    var isValidResponse: Bool {
        return isSuccessful && (httpStatusCode == 200 || httpStatusCode == nil)
    }

    var friendlyMessage: String {
        return message ?? "Something went wrong. Please try again."
    }
}

enum CCError: Error {
    case network(Error)
    case invalidResponseFormat
    case decoding(Error)
    case server(String)
    case noDataReceived

    var localizedDescription: String {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .invalidResponseFormat:
            return "Invalid or malformed response from server."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .server(let message):
            return message
        case .noDataReceived:
            return "No data received from the server."
        }
    }
}

typealias CCAPIResult<T> = Result<T, CCError>
