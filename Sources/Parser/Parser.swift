//
//  Parser.swift
//  Created by Alessandro Francucci on 01/11/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype ModelType

    func parse(data: Data) throws -> ModelType
}

// JSON

final class JsonParser<ModelType: Decodable>: ParserProtocol {
    func parse(data: Data) throws -> ModelType {
        let jsonDecoder = JSONDecoder()
        let result = try jsonDecoder.decode(ModelType.self, from: data)
        return result
    }
}

// Dictionary

enum DictionaryParserError: Error {
    case canNotCastJsonObjectToDictionary
}

final class DictionaryParser: ParserProtocol {
    func parse(data: Data) throws -> [String: Any] {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any] else {
            throw DictionaryParserError.canNotCastJsonObjectToDictionary
        }
        return dictionary
    }
}
