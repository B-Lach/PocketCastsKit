//
//  RestClientTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class RestClientTests: XCTestCase {}

private let baseURLString = "http://localhoast"

// MARK: - Init
extension RestClientTests {
    func testRestClientWithInvalidURL() {
        XCTAssertThrowsError(try RestClient(baseURLString: ""))
    }
    
    func testRestClientWithValidURL() {
        guard let client = try? RestClient(baseURLString: baseURLString) else {
            XCTFail()
            return
        }
        XCTAssertEqual(client.baseURL, URL(string: baseURLString)!)
    }
}

// MARK: - GET
@testable import PocketCastsKit
extension RestClientTests {
    func testGETInvalidPath() {
        let expec = expectation(description: "check for invalid path")
        
        let client = try! RestClient(baseURLString: baseURLString)
        client.get(path: "") { (result) in
            switch result {
            case .success(_):
                XCTFail()
            default:
            break
            }
            expec.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testGETValidPath() {
        let expec = expectation(description: "GET unit testing")
        
        var manager = NetworkManagerMock()
        manager.injectTestCode { (url, options, methodType, completion) in
            XCTAssertEqual(url, URL(string: "\(baseURLString)/get")!)
            XCTAssertEqual(options.count, 0)
            XCTAssertEqual(methodType, .GET)
            
            completion(Result.success(Data()))
        }
        
        let client = try! RestClient(baseURLString: baseURLString, manager: manager)
        client.get(path: "/get") { (res) in
            expec.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

// MARK: - POST
extension RestClientTests {
    func testPOSTInvalidPath() {
        let expec = expectation(description: "check for invalid path")
        
        let client = try! RestClient(baseURLString: baseURLString)
        client.post(path: "") { (result) in
            switch result {
            case .success(_):
                XCTFail()
            default:
                break
            }
            expec.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPOSTValidPath() {
        let expec = expectation(description: "GET unit testing")
        
        var manager = NetworkManagerMock()
        manager.injectTestCode { (url, options, methodType, completion) in
            XCTAssertEqual(url, URL(string: "\(baseURLString)/post")!)
            XCTAssertEqual(options.count, 0)
            XCTAssertEqual(methodType, .POST)
            
            completion(Result.success(Data()))
        }
        
        let client = try! RestClient(baseURLString: baseURLString, manager: manager)
        client.post(path: "/post") { (res) in
            expec.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
