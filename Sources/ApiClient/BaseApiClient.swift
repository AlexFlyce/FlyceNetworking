//
//  Response.swift
//  Created by Alessandro Francucci on 01/11/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

public protocol BaseApiClient: AnyObject {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse
}

public extension BaseApiClient {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse {
        switch response.statusCode {
        case 200...299: return .success
        case 404: return .failure(error: NetworkResponseError.notFound)
        case 401...499: return .failure(error: NetworkResponseError.authentication)
        case 500: return .failure(error: NetworkResponseError.internalServer)
        case 501...599: return .failure(error: NetworkResponseError.badRequest)
        case 600: return .failure(error: NetworkResponseError.outdated)
        default: return .failure(error: NetworkResponseError.general)
        }
    }
}
