//
//  PCKPodcast.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

public struct PCKPodcast {
    public let id: Int
    public let uuid: UUID
    public let url: URL
    public let title: String
    public let description: String
    public let thumbnail: URL
    public let author: String
    public let sortOrder: Int
}

extension PCKPodcast: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case url
        case title
        case description
        case thumbnail = "thumbnail_url"
        case author
        case sortOrder = "episodes_sort_order"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        uuid = try values.decode(UUID.self, forKey: .uuid)
        url = try values.decode(URL.self, forKey: .url)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        thumbnail = try values.decode(URL.self, forKey: .thumbnail)
        author = try values.decodeIfPresent(String.self, forKey: .author) ?? "undefined"
        sortOrder = try values.decode(Int.self, forKey: .sortOrder)
    }
}
