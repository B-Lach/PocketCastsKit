//
//  JSONParserTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit

class JSONParserTests: XCTestCase {
    let id = 5810
    let uuid = UUID(uuidString: "00414e50-2610-012e-05ba-00163e1b201c")!
    let url = URL(string: "https://ninjalooter.de")!
    let title = "Ninjalooter.de"
    let desc =  "Der Podcast der Ninjalooter befasst sich mit Spielen jeglicher Art. Insbesondere MMOs, Beta-Eindrücke und PC-Rollen- und Strategiespiele stehen auf der Debattierliste."
    let thumbnail = URL(string: "http://ninjalooter.de/blog/wp-content/uploads/NinjaCast_Logo.jpg")!
    let author = "Ninjalooter.de"
    let sortOrder = 3
    
    func testValidObjectDecoding() {
        guard let podcast = JSONParser.shared.decode(TestHelper.TestData.podcastDataWithAuthor, type: PCKPodcast.self) else {
            XCTFail()
            return
        }

        XCTAssertEqual(podcast.id, id)
        XCTAssertEqual(podcast.uuid, uuid)
        XCTAssertEqual(podcast.url, url)
        XCTAssertEqual(podcast.title, title)
        XCTAssertEqual(podcast.description, desc)
        XCTAssertEqual(podcast.thumbnail, thumbnail)
        XCTAssertEqual(podcast.author, author)
        XCTAssertEqual(podcast.sortOrder, sortOrder)
    }
    
    func testInvalidObjectDecoding() {
        let episode = JSONParser.shared.decode(TestHelper.TestData.podcastDataWithAuthor, type: PCKEpisode.self)
        
        XCTAssertNil(episode)
    }
}
