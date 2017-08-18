//
//  PCKClientTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

enum TestErrors: Error {
    case injectedError
}

@testable import PocketCastsKit
class PCKClientTests: XCTestCase {
    private var mock: NetworkManagerMock!
    private var rest: RestClient!
    private var api: PCKClient!
    private var expec: XCTestExpectation!
    private var restClient: RestClient!
    
    override func setUp() {
        expec = expectation(description: "API Client")
    }
    
    func testAuthenticateCheckProperties() {
        mock = NetworkManagerMock()
        mock.injectTestCode { (url, options, method, handler) in
            XCTAssertEqual(url, URL(string: "http://localhost/users/sign_in")!)
            XCTAssertEqual(options.count, 1)
            XCTAssertEqual(method, .POST)
            
            handler(Result.success(Data()))
        }
        
        rest = try! RestClient(baseURLString: "http://localhost", manager: mock)
        api = PCKClient(client: rest)
        
        api.authenticate(username: "user", password: "pass") { (result) in
            self.expec.fulfill()
        }
        wait(for: [expec], timeout: 2)
    }
    
    func testAuthenticateResponseError() {
        mock = NetworkManagerMock()
        mock.injectTestCode { (url, options, method, handler) in
            handler(Result.error(TestErrors.injectedError))
        }
        
        rest = try! RestClient(baseURLString: "http://localhost", manager: mock)
        api = PCKClient(client: rest)
        
        api.authenticate(username: "user", password: "pass") { (result) in
            switch result {
            case .success(_):
                XCTFail()
            default:
                break
            }
            self.expec.fulfill()
        }
        wait(for: [expec], timeout: 2)
    }
}
