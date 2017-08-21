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
    public let category: String
    public let description: String
    public let mediaType: String
    public let language: String
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
        case category
        case description
        case mediaType = "media_type"
        case language
        case thumbnail = "thumbnail_url"
        case author
        case sortOrder = "episodes_sort_order"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        uuid = try values.decode(UUID.self, forKey: .uuid)
        url = try values.decode(URL.self, forKey: .url)
        title = try values.decode(String.self, forKey: .title)
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? "undefined"
        description = try values.decode(String.self, forKey: .description)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType) ?? "undefined"
        language = try values.decodeIfPresent(String.self, forKey: .language) ?? "undefined"
        thumbnail = try values.decode(URL.self, forKey: .thumbnail)
        author = try values.decodeIfPresent(String.self, forKey: .author) ?? "undefined"
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder) ?? -1
    }
}
