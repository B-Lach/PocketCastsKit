//
//  PCKCategoryContentTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 22.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class PCKCategoryContentTests: XCTestCase {
    let author = "Financial Times"
    let title =  "FT Tech Tonic"
    let collectionId = 1169101860
    let desc = "A weekly conversation that looks at the way technology is changing our economies, societies and daily lives. Hosted by John Thornhill, innovation editor at the Financial Times."
    let thumbnail = URL(string: "http://is5.mzstatic.com/image/thumb/Podcasts127/v4/87/1f/1f/871f1f2a-e5a1-b21d-3c6f-383f5a7be63a/mza_2575122218375622535.png/170x170bb-85.jpg")!
    let uuid = UUID(uuidString: "7726e530-7d76-0134-9030-3327a14bcdba")!
    
    func testInitFromValues() {
        let content = PCKCategoryContent(author: author, title: title,
                                         collectionId: collectionId, description: desc,
                                         thumbnail: thumbnail, uuid: uuid)
        
        XCTAssertEqual(content.author, author)
        XCTAssertEqual(content.title, title)
        XCTAssertEqual(content.collectionId, collectionId)
        XCTAssertEqual(content.description, desc)
        XCTAssertEqual(content.thumbnail, thumbnail)
        XCTAssertEqual(content.uuid, uuid)
    }
    
    func testInitFromDecoder() throws {
        let decoder = TestHelper.Decoding.jsonDecoder
        
        let content = try decoder.decode(PCKCategoryContent.self, from: TestHelper.TestData.categoryContentData)
        
        
        XCTAssertEqual(content.author, author)
        XCTAssertEqual(content.title, title)
        XCTAssertEqual(content.collectionId, collectionId)
        XCTAssertEqual(content.description, desc)
        XCTAssertEqual(content.thumbnail, thumbnail)
        XCTAssertEqual(content.uuid, uuid)
    }
    
}
