//
//  NetworkManagerProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation


/// HTTP Method Types
///
/// - GET: Get Reguest
/// - POST: Post Reguest
enum MethodType: String {
    case GET = "GET"
    case POST = "POST"
}

extension MethodType: Equatable {
    static func ==(lhs: MethodType, rhs: MethodType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}


/// Possible options for a network request
///
/// - headerField]: Array of header fields to set
/// - bodyData: Body of the request
/// - urlParameter: URL Parameters
enum RequestOption {
    case headerField([(key: String, value: String)])
    case bodyData(data: Data)
    case urlParameter([String: Any])
}

internal typealias completion<T> = ((Result<T>) -> Void)

protocol NetworkManagerProtocol {
    
    /// Method to make a network request
    ///
    /// - Parameters:
    ///   - url: the URL of the request
    ///   - options: Options to use for the request
    ///   - method: The HTTP Method to use
    ///   - completion: The CompletionHandler called after the request finished
    func makeRequest(url: URL, options: [RequestOption], method: MethodType, completion: @escaping completion<(Data, HTTPURLResponse)>)
}
