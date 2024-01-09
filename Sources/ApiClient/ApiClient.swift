//
//  ApiClient.swift
//  Created by Alessandro Francucci on 01/11/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

final class ApiClient: BaseApiClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func call<ModelType, ParserType: ParserProtocol>(request: URLRequestable,
                                                     parser: ParserType) async throws -> ModelType where ParserType.ModelType == ModelType {
        guard let url = try request.asURLRequest().url else { throw ApiError.invalidURLRequest(components: request) }
        do {
            let (data, response) = try await self.session.data(from: url)
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                throw ApiError.missingResponse
            }
            let result = self.handleNetworkResponse(httpUrlResponse)
            switch result {
            case .success:
                return try parser.parse(data: data)
            case .failure(let error):
                throw ApiError.responseValidation(error: error)
            }
        } catch {
            throw ApiError.mapFromURLSessionError(error)
        }
    }
}
