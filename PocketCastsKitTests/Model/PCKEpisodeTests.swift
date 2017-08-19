//
//  PCKEpisodeTests.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest

@testable import PocketCastsKit

class PCKEpisodeTests: XCTestCase {

    let id = 1
    let uuid = UUID(uuidString: "8a788c1e-332b-4e9f-8d0a-3043276e6cb1")!
    let url =  URL(string: "https://www.gamespodcast.de/podlove/file/1371/s/feed/c/premium5/Anekdoten_Thomas_Lindemann_Enthuellungen.mp3")!
    let published = TestHelper.Decoding.dateFormatter.date(from: "2017-08-16 22:00:01")!
    let duration = 2546
    let fileType = "audio/mp3"
    let title =  "Anekdoten: Enthüllungsjournalismus in der Spielebranche"
    let podcastId = 867908
    let size = 37094736
    let podcastUUID = UUID(uuidString: "c251cdb0-4a81-0135-902b-63f4b61a9224")!
    let playingStatus = 2
    let playedUpTo = 195
    let isDeleted = false
    let starred = false
    
    func testInitFromValues() {
        var episode = PCKEpisode(id: id, uuid: uuid, url: url,
                                 publishedAt: published, duration: duration,
                                 fileType: fileType, title: title, size: size,
                                 podcastId: podcastId, podcastUUID: podcastUUID,
                                 playingStatus: playingStatus, playedUpTo: playedUpTo,
                                 isDeleted: isDeleted, starred: starred)
        
        XCTAssertEqual(episode.id, id)
        XCTAssertEqual(episode.uuid, uuid)
        XCTAssertEqual(episode.url, url)
        XCTAssertEqual(episode.publishedAt, published)
        XCTAssertEqual(episode.duration, duration)
        XCTAssertEqual(episode.fileType, fileType)
        XCTAssertEqual(episode.title, title)
        XCTAssertEqual(episode.podcastId, podcastId)
        XCTAssertEqual(episode.size, size)
        XCTAssertEqual(episode.podcastUUID, podcastUUID)
        XCTAssertEqual(episode.playingStatus, playingStatus)
        XCTAssertEqual(episode.playedUpTo, playedUpTo)
        XCTAssertEqual(episode.isDeleted, isDeleted)
        XCTAssertEqual(episode.starred, starred)
        
        // Testting nil for isDeleted & starred
        episode = PCKEpisode(id: id, uuid: uuid, url: url,
                             publishedAt: published, duration: duration,
                             fileType: fileType, title: title, size: size,
                             podcastId: podcastId, podcastUUID: podcastUUID,
                             playingStatus: playingStatus, playedUpTo: playedUpTo,
                             isDeleted: nil, starred: nil)
        
        XCTAssertEqual(episode.isDeleted, nil)
        XCTAssertEqual(episode.starred, nil)
    }
    
    func testInitFromDecoder() throws {
        let decoder = TestHelper.Decoding.jsonDecoder
        
        // Test with all data present
        var episode = try decoder.decode(PCKEpisode.self, from: TestHelper.TestData.episideDataOptionalPresent)
        
        XCTAssertEqual(episode.id, id)
        XCTAssertEqual(episode.uuid, uuid)
        XCTAssertEqual(episode.url, url)
        XCTAssertEqual(episode.publishedAt, published)
        XCTAssertEqual(episode.duration, duration)
        XCTAssertEqual(episode.fileType, fileType)
        XCTAssertEqual(episode.title, title)
        XCTAssertEqual(episode.podcastId, podcastId)
        XCTAssertEqual(episode.size, size)
        XCTAssertEqual(episode.podcastUUID, podcastUUID)
        XCTAssertEqual(episode.playingStatus, playingStatus)
        XCTAssertEqual(episode.playedUpTo, playedUpTo)
        XCTAssertEqual(episode.isDeleted, isDeleted)
        XCTAssertEqual(episode.starred, starred)
        // Test with optional data not present
        episode = try decoder.decode(PCKEpisode.self, from: TestHelper.TestData.episodeDataOptionalNotPresent)
        
        XCTAssertEqual(episode.id, -1)
        XCTAssertEqual(episode.duration, -1)
        XCTAssertEqual(episode.playingStatus, -1)
        XCTAssertEqual(episode.playedUpTo, -1)
        XCTAssertEqual(episode.isDeleted, nil)
        XCTAssertEqual(episode.starred, nil)
        // Test with duration is string
        episode = try decoder.decode(PCKEpisode.self, from: TestHelper.TestData.episodeDataDurationIsString)
        
        XCTAssertEqual(episode.duration, duration)
    }
    
}
