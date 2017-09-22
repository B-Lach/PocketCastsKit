//
//  PCKCountry.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

/// Represents a Country used in PocketCasts to filter search results
public struct PCKCountry: Decodable {
    public let code: String
    public let name: String
}
