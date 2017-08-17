//
//  PCKPodcastTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest
@testable import PocketCastsKit

class PCKPodcastTests: XCTestCase {
    // Excpected result
    let id = 5810
    let uuid = UUID(uuidString: "00414e50-2610-012e-05ba-00163e1b201c")!
    let url = URL(string: "https://ninjalooter.de")!
    let title = "Ninjalooter.de"
    let desc =  "Der Podcast der Ninjalooter befasst sich mit Spielen jeglicher Art. Insbesondere MMOs, Beta-Eindrücke und PC-Rollen- und Strategiespiele stehen auf der Debattierliste."
    let thumbnail = URL(string: "http://ninjalooter.de/blog/wp-content/uploads/NinjaCast_Logo.jpg")!
    let author = "Ninjalooter.de"
    let sortOrder = 3
    
    
    func testInitFromValues() {
        let podcast = PCKPodcast(id: id, uuid: uuid, url: url,
                                 title: title, description: desc,
                                 thumbnail: thumbnail, author: author, sortOrder: sortOrder)
        
        XCTAssertEqual(podcast.id, id)
        XCTAssertEqual(podcast.uuid, uuid)
        XCTAssertEqual(podcast.url, url)
        XCTAssertEqual(podcast.title, title)
        XCTAssertEqual(podcast.description, desc)
        XCTAssertEqual(podcast.thumbnail, thumbnail)
        XCTAssertEqual(podcast.author, author)
        XCTAssertEqual(podcast.sortOrder, sortOrder)
    }
    
    func testInitFromDecoder() throws {
        
        let decoder = TestHelper.Decoding.jsonDecoder
        
        var podcast = try decoder.decode(PCKPodcast.self, from: TestHelper.TestData.podcastDataWithAuthor)
        
        XCTAssertEqual(podcast.id, id)
        XCTAssertEqual(podcast.uuid, uuid)
        XCTAssertEqual(podcast.url, url)
        XCTAssertEqual(podcast.title, title)
        XCTAssertEqual(podcast.description, desc)
        XCTAssertEqual(podcast.thumbnail, thumbnail)
        XCTAssertEqual(podcast.author, author)
        XCTAssertEqual(podcast.sortOrder, sortOrder)
        // author can be null, seperate test case
        podcast = try decoder.decode(PCKPodcast.self, from: TestHelper.TestData.podcastDataWithoutAuthor)
        
        XCTAssertEqual(podcast.id, id)
        XCTAssertEqual(podcast.uuid, uuid)
        XCTAssertEqual(podcast.url, url)
        XCTAssertEqual(podcast.title, title)
        XCTAssertEqual(podcast.description, desc)
        XCTAssertEqual(podcast.thumbnail, thumbnail)
        XCTAssertEqual(podcast.author, "undefined")
        XCTAssertEqual(podcast.sortOrder, sortOrder)
    }
}
