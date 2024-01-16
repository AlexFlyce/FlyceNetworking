//
//  URLRequestable.swift
//  Created by Alessandro Francucci on 31/10/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

public protocol URLRequestable: URLComponeble {
    var method: HTTPMethod { get }
    var encoding: URLEncoding { get }
    
    var parameters: [String: Any]? { get set }
    mutating func addParameter(key: String, value: String)
    
    var allHTTPHeaderFields: [String : String]? { get set }
    mutating func addAuthentication(key: String, value: String)

    func asURLRequest() throws -> URLRequest
}

public extension URLRequestable {
    mutating func addParameter(key: String, value: String) {
        if parameters == nil {
            self.parameters = [String: String]()
        }
        self.parameters?[key] = value
    }

    func asURLRequest() throws -> URLRequest {
        var components = try self.urlComponents()
        let queryItems = self.parameters?.keys.map { URLQueryItem(name: $0, value: self.parameters?[$0] as? String) }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw ApiError.invalidURL(components: self)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = self.allHTTPHeaderFields
        return urlRequest
    }
    
    mutating func addAuthentication(key: String, value: String) {
        guard let passwordStringData = "\(key):\(value)".data(using: .utf8) else {
            return
        }
        let encodedCredential = passwordStringData.base64EncodedString()
        if self.allHTTPHeaderFields == nil {
            self.allHTTPHeaderFields = [String: String]()
        }
        let authKey = "Authorization"
        self.allHTTPHeaderFields?[authKey] = "Basic \(encodedCredential)"
    }
}
