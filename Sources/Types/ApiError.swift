//
//  ApiError.swift
//  Created by Alessandro Francucci on 31/10/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case invalidURL(components: URLComponeble)
    case invalidURLRequest(components: URLComponeble)
    case parametersEncoding
    case responseValidation(error: Error?)
    case missingData
    case missingResponse
    case parsing(error: Error?)
    case objectDestroyed
    case notConnectedToInternet
    case timedOut
    case unknownError(error: Error)
}

extension ApiError {
    static func mapFromURLSessionError(_ error: Error) -> Self {
        switch (error as NSError).code {
        case -1001:
            return .timedOut
        case -1009:
            return .notConnectedToInternet
        default:
            return .unknownError(error: error)
        }
    }
}
