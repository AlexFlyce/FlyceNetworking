//
//  URLComponable.swift
//  Created by Alessandro Francucci on 31/10/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

public protocol URLComponeble {
    var scheme: String { get }
    var domain: String { get }
    var port: Int? { get }
    var path: String { get }

    func endPoint() -> String
    func urlComponents() throws -> URLComponents
}

public extension URLComponeble {

    func endPoint() -> String {
        if let port = port {
            return "\(scheme)://\(domain):\(port)/\(path)"
        } else {
            return "\(scheme)://\(domain)/\(path)"
        }
    }

    func urlComponents() throws -> URLComponents {
        guard let urlComponents = URLComponents(string: endPoint()) else {
            throw ApiError.invalidURLRequest(components: self)
        }
        return urlComponents
    }
}
