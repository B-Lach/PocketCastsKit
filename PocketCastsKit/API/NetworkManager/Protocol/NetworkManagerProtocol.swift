//
//  NetworkManagerProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

enum MethodType: String {
    case GET = "GET"
    case POST = "POST"
}

extension MethodType: Equatable {
    static func ==(lhs: MethodType, rhs: MethodType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

enum RequestOption {
    case headerField([(key: String, value: String)])
    case bodyData(data: Data)
    case urlParameter([String: Any])
}

internal typealias completion<T> = ((Result<T>) -> Void)

protocol NetworkManagerProtocol {
    func makeRequest(url: URL, options: [RequestOption], method: MethodType, completion: @escaping completion<(Data, HTTPURLResponse)>)
}
