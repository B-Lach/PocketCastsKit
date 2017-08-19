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
class PCKClientTests: PCKTestCase {
    var rest: RestClient!
    var api: PCKClient!
    
    override func setUp() {
        super.setUp()
        rest = try! RestClient(baseURLString: baseURLString, manager: manager)
        api = PCKClient(client: rest)
    }
}

// MARK: - Authentication Testing
extension PCKClientTests {
    
    func testAuthenticateCheckProperties() {
        api.authenticate(username: "user", password: "pass") { (result) in
            self.expec.fulfill()
        }
        let data = "[user]email=user&[user]password=pass"
            .addingPercentEncoding(withAllowedCharacters: .urlEncoded)!
            .data(using: .utf8)!
        let request = getRequest()!
        
        XCTAssertEqual(request.url, URL(string: "http://localhost/users/sign_in")!)
        XCTAssertEqual(request.httpBody, data)
        XCTAssertEqual(request.httpMethod, MethodType.POST.rawValue)
        
        wait()
    }
    
    func testAuthenticateWithErrorResponse() {
        mock = URLSessionMock(data: nil, response: nil, error: TestErrors.injectedError)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
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
        wait()
    }
    
    func testAuthenticateIsLoggedIn() {
        let loginURL = URL(string: "https://play.pocketcasts.com/web/podcasts/index")!
        let response = HTTPURLResponse(url: loginURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: Data(), response: response, error: nil)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
        api = PCKClient(client: rest)
        
        api.authenticate(username: "user", password: "pass") { (result) in
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
    
    func testAuthenticateNotLoggedIn() {
        let loginURL = URL(string: "https://play.pocketcasts.com/users/sign_in")!
        let response = HTTPURLResponse(url: loginURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: Data(), response: response, error: nil)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
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
        wait()
    }
    
    func testIsAuthenticatedLoggedIn() {
        let loginURL = URL(string: "https://play.pocketcasts.com/web/podcasts/index")!
        let response = HTTPURLResponse(url: loginURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: Data(), response: response, error: nil)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
        api = PCKClient(client: rest)
        
        api.isAuthenticated { (result) in
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
    
    func testIsAuthenticatedNotLoggedIn() {
        let loginURL = URL(string: "https://play.pocketcasts.com/users/sign_in")!
        let response = HTTPURLResponse(url: loginURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mock = URLSessionMock(data: Data(), response: response, error: nil)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
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
        wait()
    }
}
