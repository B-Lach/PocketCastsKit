//
//  NetworkManagerTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class NetworkManagerTests: PCKTestCase {}

// MARK: - Testing MethodTypes
extension NetworkManagerTests {
    func testGETRequest() {
        manager.makeRequest(url: url, method: .GET) { (_) in
            self.expec.fulfill()
        }
        XCTAssertEqual(getRequest()?.httpMethod, MethodType.GET.rawValue)
        
        wait()
    }
    
    func testPOSTRequest() {
        manager.makeRequest(url: url, method: .POST) { (_) in
            self.expec.fulfill()
        }
        XCTAssertEqual(getRequest()?.httpMethod, MethodType.POST.rawValue)
        
        wait()
    }
}

// MARK: - Testing RequestOption
extension NetworkManagerTests {
    func testRequestWithHeaderField() {
        let option = RequestOption.headerField([("foo", "bar")])
        
        manager.makeRequest(url: url,options: [option], method: .GET) { (_) in
            self.expec.fulfill()
        }
        XCTAssertEqual(getRequest()?.value(forHTTPHeaderField: "foo"), "bar")
        
        wait()
    }

    func testRequestWithBodyData() {
        let data = "foo=bar".data(using: .utf8)!
        let option = RequestOption.bodyData(data: data)
        
        manager.makeRequest(url: url, options: [option], method: .GET) { (_) in
            self.expec.fulfill()
        }
        XCTAssertEqual(getRequest()?.httpBody, data)
        
        wait()
    }
    
    func testRequestWithURLParams() {
        let option = RequestOption.urlParameter(["foo": "bar"])
        
        manager.makeRequest(url: url, options: [option], method: .GET) { (_) in
            self.expec.fulfill()
        }
        XCTAssertEqual(getRequest()?.url?.absoluteString, "http://localhost?foo=bar")
        
        wait(for: [expec], timeout: 2)
    }
}

// MARK: Testing Response
extension NetworkManagerTests {
    func testRequestWith200Response() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: Data(), response: response, error: nil)
        manager = NetworkManager(session: mock)
        manager.makeRequest(url: url, method: .GET) { (result) in
            switch result {
            case .error(_):
                XCTFail()
            default:
                break
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testRequestWith401Response() {
        let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: Data(), response: response, error: nil)
        manager = NetworkManager(session: mock)
        manager.makeRequest(url: url, method: .GET) { (result) in
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
    
    func testRequestWithErrorResponse() {
        enum ResponseError: Error {
            case testError
        }
        
        mock = URLSessionMock(data: nil, response: nil, error: ResponseError.testError)
        manager = NetworkManager(session: mock)
        manager.makeRequest(url: url, method: .GET) { (result) in
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
    
    func testRequestWithNoDataResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: nil, response: response, error: nil)
        manager = NetworkManager(session: mock)
        manager.makeRequest(url: url, method: .GET) { (result) in
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
}
