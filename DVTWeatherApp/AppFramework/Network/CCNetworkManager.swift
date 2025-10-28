//
//  CCNetworkManager.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import Foundation
import Alamofire

class CCNetworkManager: NSObject {

    private var m_httpRequest: CCHTTPRequest
    private weak var m_delegate: CCNetworkDelegate?
    private var m_session: Session
    private var m_dataRequest: DataRequest?

    init(httpRequest: CCHTTPRequest, delegate: CCNetworkDelegate) {
        self.m_httpRequest = httpRequest
        self.m_delegate = delegate

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = httpRequest.m_timeoutInterval
        configuration.timeoutIntervalForResource = CCAPIConfig.Timeout.m_resource
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        self.m_session = Session(configuration: configuration)

        super.init()
    }

    func startRequest() {
        m_delegate?.onPreExecute(requestObject: m_httpRequest, forTaskCode: m_httpRequest.m_taskCode)

        switch m_httpRequest.m_method {
        case .get:
            executeGETRequest()
        case .post:
            executePOSTRequest()
        case .put:
            executePUTRequest()
        case .delete:
            executeDELETERequest()
        case .patch:
            executePATCHRequest()
        }
    }

    func cancelRequest() {
        m_dataRequest?.cancel()
        print("Request cancelled: \(m_httpRequest.m_taskCode.description)")
    }

    func cancelAllRequests() {
        m_session.cancelAllRequests()
        print("All requests cancelled")
    }

    private func executeGETRequest() {
        let urlString = m_httpRequest.buildURL()

        m_dataRequest = m_session.request(
            urlString,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: HTTPHeaders(m_httpRequest.m_headers)
        )

        m_dataRequest?.validate(statusCode: 200..<300).responseString { [weak self] response in
            self?.handleAlamofireResponse(response)
        }
    }

    private func executePOSTRequest() {
        m_dataRequest = m_session.request(
            m_httpRequest.m_url,
            method: .post,
            parameters: m_httpRequest.m_parameters,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(m_httpRequest.m_headers)
        )

        m_dataRequest?.validate(statusCode: 200..<300).responseString { [weak self] response in
            self?.handleAlamofireResponse(response)
        }
    }

    private func executePUTRequest() {
        m_dataRequest = m_session.request(
            m_httpRequest.m_url,
            method: .put,
            parameters: m_httpRequest.m_parameters,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(m_httpRequest.m_headers)
        )

        m_dataRequest?.validate(statusCode: 200..<300).responseString { [weak self] response in
            self?.handleAlamofireResponse(response)
        }
    }

    private func executeDELETERequest() {
        m_dataRequest = m_session.request(
            m_httpRequest.m_url,
            method: .delete,
            parameters: m_httpRequest.m_parameters,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(m_httpRequest.m_headers)
        )

        m_dataRequest?.validate(statusCode: 200..<300).responseString { [weak self] response in
            self?.handleAlamofireResponse(response)
        }
    }

    private func executePATCHRequest() {
        m_dataRequest = m_session.request(
            m_httpRequest.m_url,
            method: .patch,
            parameters: m_httpRequest.m_parameters,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(m_httpRequest.m_headers)
        )

        m_dataRequest?.validate(statusCode: 200..<300).responseString { [weak self] response in
            self?.handleAlamofireResponse(response)
        }
    }

    private func handleAlamofireResponse(_ response: AFDataResponse<String>) {
        switch response.result {
        case .success:
            handleSuccessResponse(response: response)
        case .failure:
            handleFailureResponse(response: response)
        }
    }

    private func handleSuccessResponse(response: AFDataResponse<String>) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            let httpResponse = CCHTTPResponse()
            httpResponse.m_result = .success
            httpResponse.m_statusCode = response.response?.statusCode
            httpResponse.m_rawData = response.data
            httpResponse.m_rawString = response.value

            // Parse JSON
            if let data = response.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    httpResponse.m_responseObject = jsonObject
                } catch {
                    print("JSON parsing error: \(error)")
                    httpResponse.m_error = error
                }
            }

            DispatchQueue.main.async {
                _ = self.m_delegate?.onSuccess(
                    httpResponse,
                    forTaskCode: self.m_httpRequest.m_taskCode,
                    requestObject: self.m_httpRequest
                )
            }
        }
    }

    private func handleFailureResponse(response: AFDataResponse<String>) {
        let httpResponse = CCHTTPResponse()
        httpResponse.m_result = .failure
        httpResponse.m_statusCode = response.response?.statusCode
        httpResponse.m_error = response.error
        httpResponse.m_rawData = response.data

        // Try to parse error response
        if let data = response.data {
            httpResponse.m_rawString = String(data: data, encoding: .utf8)

            do {
                let decoder = JSONDecoder()
                let errorResponse = try decoder.decode(CCBaseResponse.self, from: data)
                httpResponse.m_responseObject = errorResponse
            } catch {
                print("Error parsing failure response: \(error)")
            }
        }

        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.m_delegate?.onFailure(
                httpResponse,
                forTaskCode: self.m_httpRequest.m_taskCode,
                requestObject: self.m_httpRequest
            )
        }
    }


    // MARK: - Deinit
    deinit {
        m_dataRequest?.cancel()
        print("CCNetworkManager")
    }
}

extension CCNetworkManager {

    static func isNetworkAvailable() -> Bool {
        let reachabilityManager = NetworkReachabilityManager()
        return reachabilityManager?.isReachable ?? false
    }
}
