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
    
    private func buildNewMock(data: Data?, response: HTTPURLResponse?, error: Error?) {
        mock = URLSessionMock(data: data, response: response, error: error)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
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
        buildNewMock(data: nil, response: nil, error: TestErrors.injectedError)
        
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
        
        buildNewMock(data: Data(), response: response, error: nil)
        
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
        
        buildNewMock(data: Data(), response: response, error: nil)
        
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
        
        buildNewMock(data: Data(), response: response, error: nil)
        
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
        
        buildNewMock(data: Data(), response: response, error: nil)
        
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

// MARK: - User feed Testing
extension PCKClientTests {
    func testGetSubscriptionsIsUnauthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.unauthorizedError, response: response, error: nil)
        
        api.getSubscriptions { (result) in
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
    
    func testGetSubscriptionsIsAuthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.subscriptionsSuccessData, response: response, error: nil)
        
        api.getSubscriptions { (result) in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let podcasts):
                XCTAssertEqual(podcasts.count, 1)
                XCTAssertEqual(podcasts.first?.title, "WRINT: Realitätsabgleich")
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testGetInProgressUnauthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.unauthorizedError, response: response, error: nil)
        
        api.getEpisodesInProgress { (result) in
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
    
    func testGetInProgressIsAuthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.episodesInProgressSuccess, response: response, error: nil)
        
        api.getEpisodesInProgress { (result) in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let episodes):
                XCTAssertEqual(episodes.count, 1)
                XCTAssertEqual(episodes.first?.title, "Episode #300 - Puttenbrust")
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testGetNewEpisodesUnauthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.unauthorizedError, response: response, error: nil)
        
        api.getNewEpisodes { (result) in
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
    
    func testGetNewEpisodesIsAuthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.newEpisodesData, response: response, error: nil)
        
        api.getNewEpisodes { (result) in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let episodes):
                XCTAssertEqual(episodes.count, 1)
                XCTAssertEqual(episodes.first?.duration, 5893)
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testGetStarredEpisodesUnauthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.unauthorizedError, response: response, error: nil)
        
        api.getStarredEpisodes { (result) in
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
    
    func testGetStarredEpisodesIsAuthorized() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.starredEpisodesData, response: response, error: nil)
        
        api.getStarredEpisodes { (result) in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let episodes):
                XCTAssertEqual(episodes.count, 0)
            }
            self.expec.fulfill()
        }
        wait()
    }
}
