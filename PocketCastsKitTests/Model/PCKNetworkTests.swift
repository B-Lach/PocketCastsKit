//
//  PCKNetworkTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class PCKNetworkTests: XCTestCase {
    let id = 12
    let title = "CNET"
    let networkDescription = "Reviews & first looks"
    let imgURL = URL(string: "http://static.pocketcasts.com/discover/images/networks/thumbnails/12/original/cnet.png")!
    let color = "#222224"
    
    func testInitFromValues() {
        let network = PCKNetwork(id: id, title: title,
                                 description: networkDescription,
                                 imgURL: imgURL, color: color)
        
        XCTAssertEqual(network.id, id)
        XCTAssertEqual(network.title, title)
        XCTAssertEqual(network.description, networkDescription)
        XCTAssertEqual(network.imgURL, imgURL)
        XCTAssertEqual(network.color, color)
    }
    
    func testInitFromDecoder() throws {
        let decoder = TestHelper.Decoding.jsonDecoder
        
        let net = try decoder.decode(PCKNetwork.self, from: TestHelper.TestData.networkData)
        
        XCTAssertEqual(net.id, id)
        XCTAssertEqual(net.title, title)
        XCTAssertEqual(net.description, networkDescription)
        XCTAssertEqual(net.imgURL, imgURL)
        XCTAssertEqual(net.color, color)
    }
    
}
