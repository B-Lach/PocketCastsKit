//
//  RestClientTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class RestClientTests: PCKTestCase {
    
    private func fulfill() {
        expec.fulfill()
        wait()
    }
}

// MARK: - Testing initializing
extension RestClientTests {
    func testRestClientWithInvalidURL() {
        XCTAssertThrowsError(try RestClient(baseURLString: ""))
        fulfill()
    }
    
    func testRestClientWithValidURL() {
        guard let client = try? RestClient(baseURLString: baseURLString) else {
            XCTFail()
            return
        }
        XCTAssertEqual(client.baseURL, URL(string: baseURLString)!)
        fulfill()
    }
}

// MARK: - Testing GET
@testable import PocketCastsKit
extension RestClientTests {
    func testGETInvalidPath() {
        let client = try! RestClient(baseURLString: baseURLString)
        client.get(path: "") { (result) in
            switch result {
            case .success(_):
                XCTFail()
            default:
            break
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testGETValidPath() {
        let client = try! RestClient(baseURLString: baseURLString, manager: manager)
        
        client.get(path: "/get") { (res) in
            self.expec.fulfill()
        }
        
        let request = getRequest()!
        XCTAssertEqual(request.url, URL(string: "\(self.baseURLString)/get")!)
        XCTAssertEqual(request.allHTTPHeaderFields!, [String:String]())
        XCTAssertEqual(request.httpBody, nil)
        XCTAssertEqual(request.httpMethod, MethodType.GET.rawValue)
        
        wait()
    }
}

// MARK: - POST
extension RestClientTests {
    func testPOSTInvalidPath() {
        let client = try! RestClient(baseURLString: baseURLString)
        client.post(path: "") { (result) in
            switch result {
            case .success(_):
                XCTFail()
            default:
                break
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testPOSTValidPath() {
        let client = try! RestClient(baseURLString: baseURLString, manager: manager)
        client.post(path: "/post") { (res) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.url, URL(string: "\(self.baseURLString)/post")!)
        XCTAssertEqual(request.allHTTPHeaderFields!, [String:String]())
        XCTAssertEqual(request.httpBody, nil)
        XCTAssertEqual(request.httpMethod, MethodType.POST.rawValue)
        
        wait()
    }
}
