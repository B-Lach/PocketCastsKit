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

struct RestClient: RestProtocol {
    private let manager: NetworkManager
    private(set) var baseURL: URL
    
    init(baseURLString: String, manager: NetworkManager = NetworkManager()) throws {
        guard let url = URL(string: baseURLString) else {
            throw RestClientErrors.baseURLStringNotValid(stirng: baseURLString)
        }
        self.baseURL = url
        self.manager = manager
    }

    func get(path: String, options: [RequestOption] = [], completion: @escaping ((Result<Data>) -> Void)) {
        guard let url = URL(string: path, relativeTo: baseURL)?.absoluteURL else {
            completion(Result.error(RestClientErrors.pathNotValid(path: path)))
            
            return
        }
        manager.makeRequest(url: url, options: options, method: .GET, completion: completion)
    }
    
    func post(path: String, options: [RequestOption] = [], completion: @escaping ((Result<Data>) -> Void)) {
        guard let url = URL(string: path, relativeTo: baseURL)?.absoluteURL else {
            completion(Result.error(RestClientErrors.pathNotValid(path: path)))
            
            return
        }
        manager.makeRequest(url: url, options: options, method: .POST, completion: completion)
    }
}
