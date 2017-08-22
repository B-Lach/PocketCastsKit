//
//  PCKNetwork.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 21.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

public struct PCKNetwork: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imgURL = "image_url"
        case color
    }
    
    let id: Int
    let title: String
    let description: String
    let imgURL: URL
    let color: String
}
