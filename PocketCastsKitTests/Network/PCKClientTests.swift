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
        api = PCKClient(client: rest, globalClient: rest)
    }
    
    private func buildNewMock(data: Data?, response: HTTPURLResponse?, error: Error?) {
        mock = URLSessionMock(data: data, response: response, error: error)
        manager = NetworkManager(session: mock)
        rest = try! RestClient(baseURLString: "http://localhost", manager: manager)
        api = PCKClient(client: rest, globalClient: rest)
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

// MARK: - Episode action tests
extension PCKClientTests {
    func testGetShowNotesCheckProperties() {
        let url = URL(string: baseURLString + "/web/episodes/show_notes.json")!
        let uuid = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        
        api.getShowNotes(for: uuid) { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        let dict = try! JSONSerialization.jsonObject(with: request.httpBody!) as? [String: Any]
        
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict!["uuid"] as? String, uuid.uuidString)
        XCTAssertEqual(request.url, url)
        
        wait()
    }
    
    func testGetShowNotesSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuid = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        
        buildNewMock(data: TestHelper.TestData.getShowNotesResponseData, response: response, error: nil)
        
        api.getShowNotes(for: uuid) { (result) in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let notes):
                XCTAssertEqual(notes, "This is a test message")
            }
            self.expec.fulfill()
        }
        wait()
    }
    
    func testUpdatePlayingPositionCheckProperties() {
        let url = URL(string: baseURLString + "/web/episodes/update_episode_position.json")!
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let position = 3000
        
        api.setPlayingPosition(for: uuidE, podcast: uuidP, position: position) { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        let dict = try! JSONSerialization.jsonObject(with: request.httpBody!) as? [String: Any]
        
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict!["uuid"] as? String, uuidE.uuidString)
        XCTAssertEqual(dict!["podcast_uuid"] as? String, uuidP.uuidString)
        XCTAssertEqual(dict!["played_up_to"] as? Int, position)
        XCTAssertEqual(dict!["playing_status"] as? Int, PlayingStatus.playing.rawValue)
        XCTAssertEqual(request.url, url)
        
        wait()
    }
    
    func testUpdatePlayingPositionErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let position = 3000
        
        buildNewMock(data: TestHelper.TestData.setStarredErrorResponseData, response: response, error: nil)
        
        api.setPlayingPosition(for: uuidE, podcast: uuidP, position: position) { (result) in
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
    
    func testUpdatePlayingPositionSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let position = 3000
        
        buildNewMock(data: TestHelper.TestData.setStarredSuccessResponseData, response: response, error: nil)
        
        api.setPlayingPosition(for: uuidE, podcast: uuidP, position: position) { (result) in
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
    
    func testUpdatePlayingStatusCheckProperties() {
        let url = URL(string: baseURLString + "/web/episodes/update_episode_position.json")!
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let status = PlayingStatus.playing
        let data = "podcast_uuid=\(uuidP.uuidString)&playing_status=\(status.rawValue)&uuid=\(uuidE.uuidString)"
            .addingPercentEncoding(withAllowedCharacters: .urlEncoded)!
            .data(using: .utf8)!
        
        api.setPlayingStatus(for: uuidE, podcast: uuidP, status: status) { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!

        XCTAssertEqual(request.httpBody, data)
        XCTAssertEqual(request.url, url)
        
        wait()
    }
    
    func testUpdatePlayingStatusErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let status = PlayingStatus.playing
        
        buildNewMock(data: TestHelper.TestData.setStarredErrorResponseData, response: response, error: nil)
        
        api.setPlayingStatus(for: uuidE, podcast: uuidP, status: status) { (result) in
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
    
    func testUpdatePlayingStatusSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let status = PlayingStatus.playing
        
        buildNewMock(data: TestHelper.TestData.setStarredSuccessResponseData, response: response, error: nil)
        
        api.setPlayingStatus(for: uuidE, podcast: uuidP, status: status) { (result) in
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
    
    func testUpdateStarredCheckProperties() {
        let url = URL(string: baseURLString + "/web/episodes/update_episode_star.json")!
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        let data = "podcast_uuid=\(uuidP.uuidString)&starred=1&uuid=\(uuidE.uuidString)"
            .addingPercentEncoding(withAllowedCharacters: .urlEncoded)!
            .data(using: .utf8)!
        
        api.setStarred(for: uuidE, podcast: uuidP, starred: true) { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.httpBody, data)
        XCTAssertEqual(request.url, url)
        
        wait()
    }
    
    func testUpdateStarredErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        
        buildNewMock(data: TestHelper.TestData.setStarredErrorResponseData, response: response, error: nil)
        
        api.setStarred(for: uuidE, podcast: uuidP, starred: true) { (result) in
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
    
    func testUpdateStarredSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuidP = UUID(uuidString: "f803fde0-7b18-0132-e4c4-5f4c86fd3263")!
        let uuidE = UUID(uuidString: "151a34fa-63cc-4bb7-9476-bcbc3e1dd640")!
        
        buildNewMock(data: TestHelper.TestData.setStarredSuccessResponseData, response: response, error: nil)
        
        api.setStarred(for: uuidE, podcast: uuidP, starred: true) { (result) in
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
}

// MARK: - Podcast action tests
extension PCKClientTests {
    func testUnsubscribeCheckProperties() {
        let uuid = UUID(uuidString: "9a297c90-4a11-0135-902b-63f4b61a9224")!
        let url = URL(string: baseURLString + "/web/podcasts/unsubscribe.json")!
        
        let data = "uuid=\(uuid.uuidString)"
            .addingPercentEncoding(withAllowedCharacters: .urlEncoded)!
            .data(using: .utf8)!
        
        api.unsubscribe(podcast: uuid) { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.httpBody, data)
        XCTAssertEqual(request.url, url)
        
        wait()
    }
    
    func testUnsubscribeErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuid = UUID(uuidString: "9a297c90-4a11-0135-902b-63f4b61a9224")!
        
        buildNewMock(data: TestHelper.TestData.setStarredErrorResponseData, response: response, error: nil)
        
        api.unsubscribe(podcast: uuid) { (result) in
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
    
    func testUnsubscribeSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuid = UUID(uuidString: "9a297c90-4a11-0135-902b-63f4b61a9224")!
        
        buildNewMock(data: TestHelper.TestData.setStarredSuccessResponseData, response: response, error: nil)
        
        api.unsubscribe(podcast: uuid) { (result) in
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
    
    func testSubscribeCheckProperties() {
        let uuid = UUID(uuidString: "9a297c90-4a11-0135-902b-63f4b61a9224")!
        let url = URL(string: baseURLString + "/web/podcasts/subscribe.json")!
        
        let data = "uuid=\(uuid.uuidString)"
            .addingPercentEncoding(withAllowedCharacters: .urlEncoded)!
            .data(using: .utf8)!
        
        api.subscribe(podcast: uuid) { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.httpBody, data)
        XCTAssertEqual(request.url, url)
        
        wait()
    }
    
    func testSubscribeErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuid = UUID(uuidString: "9a297c90-4a11-0135-902b-63f4b61a9224")!
        
        buildNewMock(data: TestHelper.TestData.setStarredErrorResponseData, response: response, error: nil)
        
        api.subscribe(podcast: uuid) { (result) in
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
    
    func testSubscribeSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let uuid = UUID(uuidString: "9a297c90-4a11-0135-902b-63f4b61a9224")!
        
        buildNewMock(data: TestHelper.TestData.setStarredSuccessResponseData, response: response, error: nil)
        
        api.subscribe(podcast: uuid) { (result) in
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
}

// MARK: Global action tests
extension PCKClientTests {
    func testGetTrendingCheckProperties() {
        let url = URL(string: baseURLString + "/discover/json/trending.json")!
        api.getTrending { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, MethodType.GET.rawValue)
        
        wait()
    }
    
    func testGetTrendingErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.globalErrorResponseData, response: response, error: nil)
        
        api.getTrending { (result) in
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
    
    func testGetTrendingSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.globalSuccessResponseData, response: response, error: nil)
        
        api.getTrending { (result) in
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
    
    func testGetFeaturedCheckProperties() {
        let url = URL(string: baseURLString + "/discover/json/featured.json")!
        api.getFeatured { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, MethodType.GET.rawValue)
        
        wait()
    }
    
    func testGetFeaturedErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.globalErrorResponseData, response: response, error: nil)
        
        api.getFeatured { (result) in
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
    
    func testGetFeaturedSuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.globalSuccessResponseData, response: response, error: nil)
        
        api.getFeatured { (result) in
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
    
    func testGetTop100CheckProperties() {
        let url = URL(string: baseURLString + "/discover/json/popular_world.json")!
        api.getTop100 { (_) in
            self.expec.fulfill()
        }
        let request = getRequest()!
        
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, MethodType.GET.rawValue)
        
        wait()
    }
    
    func testGetTop100ErrorResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.globalErrorResponseData, response: response, error: nil)
        
        api.getTop100 { (result) in
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
    
    func testGetTop100SuccessResponse() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        buildNewMock(data: TestHelper.TestData.globalSuccessResponseData, response: response, error: nil)
        
        api.getTop100 { (result) in
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
}
