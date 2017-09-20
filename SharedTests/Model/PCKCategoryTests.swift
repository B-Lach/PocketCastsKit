//
//  PCKCategoryTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class PCKCategoryTests: XCTestCase {
    let id = 1
    let catName = "Arts"
    
    func testInitFromValues() {
        let cat = PCKCategory(id: id, name: catName)
        
        XCTAssertEqual(cat.id, id)
        XCTAssertEqual(cat.name, catName)
    }
    
    func testInitFromDecoder() throws {
        let decoder = TestHelper.Decoding.jsonDecoder
        
        let cat = try decoder.decode(PCKCategory.self, from: TestHelper.TestData.categoryData)
        
        XCTAssertEqual(cat.id, 15)
        XCTAssertEqual(cat.name, "Technology")
    }
}
