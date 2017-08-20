//
//  JSONParser.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

private struct ParserConstants {
    static let dateFormat: String = "yyyy-MM-dd' 'HH:mm:ss"
}

struct JSONParser {
    static let shared = JSONParser()
    
    var customDateFormatter: DateFormatter?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = ParserConstants.dateFormat
        
        return formatter
    }
    
    private init() {}
}

// MARK: Decode Data to Object
extension JSONParser {
    func decode<T: Decodable>(_ data: Data, type: T.Type) -> T? {
        let formatter = customDateFormatter ?? dateFormatter
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let object = try? decoder.decode(type, from: data) else {
            return nil
        }
        return object
    }
}

extension JSONParser {
    func encode(dictionary: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }
}
