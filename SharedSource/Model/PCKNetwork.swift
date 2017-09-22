//
//  PCKNetwork.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

/// Represents a Network in PocketCasts
/// Used only to discover new Podcasts
public struct PCKNetwork: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imgURL = "image_url"
        case color
    }
    
    public let id: Int
    public let title: String
    public let description: String
    public let imgURL: URL
    public let color: String
}
