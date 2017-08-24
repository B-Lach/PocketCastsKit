//
//  RestProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

protocol RestProtocol {
    /// Make a GET Request
    ///
    /// - Parameters:
    ///   - path: Relative path of the resource
    ///   - options: Options to set for the request
    ///   - completion: The CompletionHandler called after the request finished
    func get(path: String, options: [RequestOption], completion: @escaping completion<(Data, HTTPURLResponse)>)
    /// Make a POST Request
    ///
    /// - Parameters:
    ///   - path: Relative path of the resource
    ///   - options: Options to set for the request
    ///   - completion: The CompletionHandler called after the request finished
    func post(path: String, options: [RequestOption], completion: @escaping completion<(Data, HTTPURLResponse)>)
}
