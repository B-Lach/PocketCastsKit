//
//  URLSessionMock.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

private class URLSessionDataTaskMock: URLSessionDataTask {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var completionHandler: CompletionHandler?
    var injectedResponse: (Data?, URLResponse?, Error?)?
    
    override func resume() {
        completionHandler?(injectedResponse?.0, injectedResponse?.1, injectedResponse?.2)
    }
}

class URLSessionMock: URLSessionProtocol {
    private let dataTaskMock: URLSessionDataTaskMock
    
    var request: URLRequest?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.injectedResponse = (data, response, error)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        dataTaskMock.completionHandler = completionHandler
        
        return dataTaskMock
    }
    
    
}
