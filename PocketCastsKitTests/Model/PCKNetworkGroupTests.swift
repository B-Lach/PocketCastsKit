//
//  PCKNetworkGroupTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class PCKNetworkGroupTests: XCTestCase {
    let title =  "\"Movie Date\" from The Takeaway"
    let desc = "Each week, Newsday film critic Rafer Guzman and Takeaway producer Kristen Meinzer get in a heated, but friendly debate about the movies."
    let imgURL =  URL(string: "http://static.pocketcasts.com/discover/images/200/d48bf4e0-2ce1-012e-09dd-00163e1b201c.jpg")!
    let ppu =  UUID(uuidString: "d48bf4e0-2ce1-012e-09dd-00163e1b201c")!
    let uuid = UUID(uuidString: "d48bf4e0-2ce1-012e-09dd-00163e1b201c")!
    let fileType = "audio/mp3"
    
    func testInitFromValues() {
        let podcast = PCKNetworkPodcast(uuid: uuid, fileType: fileType)
        
        XCTAssertEqual(podcast.uuid, uuid)
        XCTAssertEqual(podcast.fileType, fileType)
        
        let group = PCKNetworkGroup(title: title, description: desc,
                                    imgURL: imgURL, ppu: ppu, podcasts: [podcast])
        
        XCTAssertEqual(group.title, title)
        XCTAssertEqual(group.description, desc)
        XCTAssertEqual(group.imgURL, imgURL)
        XCTAssertEqual(group.ppu, ppu)
        XCTAssertEqual(group.title, title)
        XCTAssertEqual(group.podcasts.count, 1)
        XCTAssertEqual(group.podcasts.first?.uuid, uuid)
        XCTAssertEqual(group.podcasts.first?.fileType, fileType)
    }
    
    func testInitFromDecoder() throws {
        let decoder = TestHelper.Decoding.jsonDecoder
        
        let group = try decoder.decode(PCKNetworkGroup.self, from: TestHelper.TestData.groupData)
        
        XCTAssertEqual(group.title, title)
        XCTAssertEqual(group.description, desc)
        XCTAssertEqual(group.imgURL, imgURL)
        XCTAssertEqual(group.ppu, ppu)
        XCTAssertEqual(group.podcasts.count, 1)
        XCTAssertEqual(group.podcasts.first?.uuid, uuid)
        XCTAssertEqual(group.podcasts.first?.fileType, nil)
    }
}
