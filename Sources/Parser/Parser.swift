//
//  Parser.swift
//  Created by Alessandro Francucci on 01/11/2019.
//  Copyright © 2019 Alessandro Francucci. All rights reserved.
//

import Foundation

public protocol ParserProtocol {
    associatedtype ModelType

    func parse(data: Data) throws -> ModelType
}

// JSON

public final class JsonParser<ModelType: Decodable>: ParserProtocol {
    
    public init() { }
    
    public func parse(data: Data) throws -> ModelType {
        let jsonDecoder = JSONDecoder()
        let result = try jsonDecoder.decode(ModelType.self, from: data)
        return result
    }
}

// Dictionary

public enum DictionaryParserError: Error {
    case canNotCastJsonObjectToDictionary
}

public final class DictionaryParser: ParserProtocol {
    
    public init() { }
    
    public func parse(data: Data) throws -> [String: Any] {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any] else {
            throw DictionaryParserError.canNotCastJsonObjectToDictionary
        }
        return dictionary
    }
}
