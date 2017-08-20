//
//  PCKClientProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

public enum PlayingStatus: Int {
    case unplayed = 0
    case playing = 2
    case played = 3
}

protocol PCKClientProtocol {
    // MARK: - Authentication
    func authenticate(username: String, password: String, completion: @escaping completion<Bool>)
    func isAuthenticated(completion: @escaping completion<Bool>)
    // MARK: - User Feeds
    func getSubscriptions(completion: @escaping completion<[PCKPodcast]>)
    func getNewEpisodes(completion: @escaping completion<[PCKEpisode]>)
    func getEpisodesInProgress(completion: @escaping completion<[PCKEpisode]>)
    func getStarredEpisodes(completion: @escaping completion<[PCKEpisode]>)
    // MARK: - Episode Actions
    func setStarred(for episode: UUID, podcast: UUID, starred: Bool, completion: @escaping completion<Bool>)
}
