//
//  PCKTestCase.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 19.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class PCKTestCase: XCTestCase {
    public let url = URL(string: "http://localhost")!
    public let baseURLString = "http://localhost"
   
    public var expec: XCTestExpectation!
    public var mock: URLSessionMock!
    public var manager: NetworkManager!
    
    override func setUp() {
        expec = expectation(description: "PocketCastsKit Testing")
        mock = URLSessionMock(data: nil, response: nil, error: nil)
        manager = NetworkManager(session: mock)
    }
    
    public func getRequest() -> URLRequest? {
        if let request = mock.request {
            return request
        }
        XCTFail()
        return nil
    }
    
    public func wait() {
        wait(for: [expec], timeout: 2)
    }
}
