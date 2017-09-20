//
//  PCKCountryTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit
class PCKCountryTests: XCTestCase {
    let code = "us"
    let countryName = "United States"
    
    func testInitFromValues() {
        let country = PCKCountry(code: code, name: countryName)
        
        XCTAssertEqual(country.code, code)
        XCTAssertEqual(country.name, countryName)
    }
    
    func testInitFromDecoder() throws {
        let decoder = TestHelper.Decoding.jsonDecoder
        
        let country = try decoder.decode(PCKCountry.self, from: TestHelper.TestData.countryData)
        
        XCTAssertEqual(country.code, "de")
        XCTAssertEqual(country.name, "Germany")
    }
}
