//
//  PCKCategoryPodcast.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 22.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

public struct PCKCategoryContent: Decodable {
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case collectionId = "collection_id"
        case description
        case thumbnail = "thumbnail_url"
        case uuid
    }
    
    let author: String
    let title: String
    let collectionId: Int
    let description: String
    let thumbnail: URL
    let uuid: UUID
}
