//
//  PCKNetworkGroup.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation


/// Represents a Group of a PCKNetwork
public struct PCKNetworkGroup: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case imgURL = "image_url"
        case ppu
        case podcasts
    }
    
    public let title: String
    public let description: String
    public let imgURL: URL
    // TODO: - No idea so far - private podcast uuid ?
    public let ppu: UUID
    public let podcasts: [PCKNetworkPodcast]
 }

public struct PCKNetworkPodcast: Decodable {
    private enum CodingKeys: String, CodingKey {
        case uuid
        case fileType = "file_type"
    }
    public let uuid: UUID
    public let fileType: String?
}
