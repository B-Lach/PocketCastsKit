//
//  NetworkManagerMock.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

enum NetworkManagerMockErorrs: Error {
    case injectionHandlerMissing
}

struct NetworkManagerMock: NetworkManagerProtocol {
    typealias InjectionHandler = ((_ url: URL, _ options: [RequestOption], _ method: MethodType, _ completion: @escaping completion<Data>) -> Void)
    
    private var injectedCode: InjectionHandler?
    
    mutating func injectTestCode(code: @escaping InjectionHandler) {
        injectedCode = code
    }
    
    func makeRequest(url: URL, options: [RequestOption], method: MethodType, completion: @escaping completion<Data>) {
        if let inject = injectedCode {
            inject(url, options, method, completion)
        } else {
            completion(Result.error(NetworkManagerMockErorrs.injectionHandlerMissing))
        }
    }
}

