//
//  PCKCategory.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

/// Represents a Podcast Category in PocketCasts,
/// Used to filter Podcasts
public struct PCKCategory: Decodable {
    let id: Int
    let name: String
}
