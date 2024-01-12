//
//  NetworkResponse.swift
//  Created by Alessandro Francucci on 01/11/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

public enum NetworkResponse {
    case success
    case failure(error: NetworkResponseError)
}

public enum NetworkResponseError: Error {
    case general
    case authentication
    case internalServer
    case notFound
    case badRequest
    case outdated
    case noData
    case unableToDecode

    public var localizedDescription: String {
        switch self {
        case .general: return "Network request failed."
        case .authentication: return "You need to be authenticated first."
        case .notFound: return "Resource not found in the server"
        case .internalServer: return "Internal Server Error"
        case .badRequest: return "Bad request"
        case .outdated: return "The url you requested is outdated."
        case .noData: return "Response returned with no data to decode."
        case .unableToDecode: return "We could not decode the response."
        }
    }
}
