//
//  RestClient.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

enum RestClientErrors: Error {
    case baseURLStringNotValid(stirng: String)
    case pathNotValid(path: String)
}

/// RestClient (atm only GET and POST) to make Network Requests
class RestClient: RestProtocol {
    private let manager: NetworkManager
    private(set) var baseURL: URL
    
    /// Contructor
    ///
    /// - Parameters:
    ///   - baseURLString: The Base URL of the Backend as String
    ///   - manager: (optional) The underlying Manager to make the Request - Can be set for Unit Testing
    /// - Throws: If the given Base URL String is not valid
    init(baseURLString: String, manager: NetworkManager = NetworkManager()) throws {
        guard let url = URL(string: baseURLString) else {
            throw RestClientErrors.baseURLStringNotValid(stirng: baseURLString)
        }
        self.baseURL = url
        self.manager = manager
    }
    
    func get(path: String, options: [RequestOption] = [], completion: @escaping ((Result<(Data, HTTPURLResponse)>) -> Void)) {
        guard let url = URL(string: path, relativeTo: baseURL)?.absoluteURL else {
            completion(Result.error(RestClientErrors.pathNotValid(path: path)))
            
            return
        }
        manager.makeRequest(url: url, options: options, method: .GET, completion: completion)
    }
    
    func post(path: String, options: [RequestOption] = [], completion: @escaping ((Result<(Data, HTTPURLResponse)>) -> Void)) {
        guard let url = URL(string: path, relativeTo: baseURL)?.absoluteURL else {
            completion(Result.error(RestClientErrors.pathNotValid(path: path)))
            
            return
        }
        manager.makeRequest(url: url, options: options, method: .POST, completion: completion)
    }
}
