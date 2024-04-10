//
//  ApiClient.swift
//  Created by Alessandro Francucci on 01/11/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

public final class ApiClient: BaseApiClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func call<ModelType, ParserType: ParserProtocol>(
        request: URLRequestable,
        parser: ParserType) async throws
    -> ModelType where ParserType.ModelType == ModelType {
        let data = try await self.call(request: request)
        return try parser.parse(data: data)
    }
    
    public func call(request: URLRequestable) async throws -> Data {
        guard try request.asURLRequest().url != nil else { throw ApiError.invalidURLRequest(components: request) }
        do {
            let (data, response) = try await self.session.data(for: request.asURLRequest())
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                throw ApiError.missingResponse
            }
            let result = self.handleNetworkResponse(httpUrlResponse)
            switch result {
            case .success:
                return data
            case .failure(let error):
                throw ApiError.responseValidation(error: error)
            }
        } catch {
            throw ApiError.mapFromURLSessionError(error)
        }
    }
}
