//
//  PCKEpisode.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

public struct PCKEpisode {
    public let id: Int
    public let uuid: UUID
    public let url: URL
    public let publishedAt: Date
    public let duration: Int
    public let fileType: String
    public let title: String
    public let size: Int
    public let podcastId: Int
    public let podcastUUID: UUID?
    public var playingStatus: Int
    public var playedUpTo: Int
    public var isDeleted: Bool?
    public var starred: Bool?
}

extension PCKEpisode: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case url
        case publishedAt = "published_at"
        case duration
        case fileType = "file_type"
        case title
        case size
        case podcastId = "podcast_id"
        case podcastUUID = "podcast_uuid"
        case playingStatus = "playing_status"
        case playedUpTo = "played_up_to"
        case isDeleted  = "is_deleted"
        case starred
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        uuid = try values.decode(UUID.self, forKey: .uuid)
        url = try values.decode(URL.self, forKey: .url)
        publishedAt = try values.decode(Date.self, forKey: .publishedAt)
        // Sometimes duration is a String sometimes it's an Integer and it can be null as well -  oh boy 😒
        if let durationString = try? values.decode(String.self, forKey: .duration) {
            duration = Int(durationString) ?? -1
        } else {
            duration = try values.decodeIfPresent(Int.self, forKey: .duration) ?? -1
        }
        fileType = try values.decode(String.self, forKey: .fileType)
        title = try values.decode(String.self, forKey: .title)
        size = try values.decode(Int.self, forKey: .size)
        podcastId = try values.decodeIfPresent(Int.self, forKey: .podcastId) ?? -1
        podcastUUID = try values.decodeIfPresent(UUID.self, forKey: .podcastUUID)
        playingStatus = try values.decodeIfPresent(Int.self, forKey: .playingStatus) ?? -1
        playedUpTo = try values.decodeIfPresent(Int.self, forKey: .playedUpTo) ?? -1
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        starred = try values.decodeIfPresent(Bool.self, forKey: .starred)
    }
}
