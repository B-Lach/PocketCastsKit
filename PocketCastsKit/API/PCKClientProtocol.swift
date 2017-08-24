//
//  PCKClientProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation


/// Enum representing the PlayingStatus of an Episode
///
/// - unplayed: The Episode was never player
/// - playing: The Episode is currently playing
/// - played: The Episode was played to the end
public enum PlayingStatus: Int {
    case unplayed = 0
    case playing = 2
    case played = 3
}


/// Enum representing the Sort Order
///
/// - ascending: Sort old to new
/// - descending: Sort new to old
public enum SortOrder: Int {
    case ascending = 2
    case descending = 3
}

protocol PCKClientProtocol {
    // MARK: - Authentication
    /// Authenticate as a valid User
    ///
    /// - Parameters:
    ///   - username: The Username
    ///   - password: The Password
    ///   - completion: The CompletionHandler called after the request finished
    func authenticate(username: String, password: String, completion: @escaping completion<Bool>)
    /// Check if the User is authenticated
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func isAuthenticated(completion: @escaping completion<Bool>)
    // MARK: - User Feeds
    /// Get all subscribed Podcasts for the authenticated User
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getSubscriptions(completion: @escaping completion<[PCKPodcast]>)
    /// Get all new Episodes for the authenticated User
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getNewEpisodes(completion: @escaping completion<[PCKEpisode]>)
    /// Get all Episodes with progress for the authenticated User
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getEpisodesInProgress(completion: @escaping completion<[PCKEpisode]>)
    /// Get all starred Episodes for the authenticated User
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getStarredEpisodes(completion: @escaping completion<[PCKEpisode]>)
    // MARK: - Episode Actions
    /// Set the starred option of an Episode
    ///
    /// - Parameters:
    ///   - episode: The UUID of the Episode
    ///   - podcast: The UUID of the Podcast
    ///   - starred: Bool indicating if the Episode is starred or not
    ///   - completion: The CompletionHandler called after the request finished
    func setStarred(for episode: UUID, podcast: UUID, starred: Bool, completion: @escaping completion<Bool>)
    /// Set the PlayingStatus of an Episode
    ///
    /// - Parameters:
    ///   - episode: The UUID of the Episode
    ///   - podcast: The UUID of the Podcast
    ///   - status: The Status to set
    ///   - completion: The CompletionHandler called after the request finished
    func setPlayingStatus(for episode: UUID, podcast: UUID, status: PlayingStatus, completion: @escaping completion<Bool>)
    /// Set the current position of a playing Episode
    ///
    /// - Parameters:
    ///   - episode: The UUID of the Episode
    ///   - podcast: The UUID of the Podcast
    ///   - position: The Position to set as Int
    ///   - completion: The CompletionHandler called after the request finished
    func setPlayingPosition(for episode: UUID, podcast: UUID, position: Int, completion: @escaping completion<Bool>)
    /// Get the Show Notes of an Episode
    ///
    /// - Parameters:
    ///   - episode: The UUID of the Episode
    ///   - completion: The CompletionHandler called after the request finished
    func getShowNotes(for episode: UUID, completion: @escaping completion<String>)
    /// Get a specific Episode of a given Podcast
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the Episode
    ///   - podcast: the UUID of the Podcast
    ///   - completion: The CompletionHandler called after the request finished
    func getEpisode(with uuid: UUID, of podcast: UUID, completion: @escaping completion<PCKEpisode>)
    // MARK: - Podcast Actions
    /// Subscribe to a Podcast
    ///
    /// - Parameters:
    ///   - podcast: The UUID of the Podcast
    ///   - completion: The CompletionHandler called after the request finished
    func subscribe(podcast: UUID, completion: @escaping completion<Bool>)
    /// Unsubscribe from a Podcast
    ///
    /// - Parameters:
    ///   - podcast: The UUID of the Podcast
    ///   - completion: The CompletionHandler called after the request finished
    func unsubscribe(podcast: UUID, completion: @escaping completion<Bool>)
    /// Get Episodes of a given Podcast
    ///
    /// - Parameters:
    ///   - podcast: The UUID of the Podcast
    ///   - page: <b>optaional</b> If paging is available, use this parameter to define the page you want to fetch
    ///   - order: <b>optaional</b> Sepcifies if you want to fetch newes or oldes first. Default is descending
    ///   - completion: The CompletionHandler called after the request finished
    func getEpisodes(for podcast: UUID,
                     page: Int, order: SortOrder,
                     completion: @escaping completion<(episodes:[PCKEpisode], order: SortOrder, nextPage: Int)>)
    /// Get a Podcast by a specific UUID
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the Podcast
    ///   - completion: The CompletionHandler called after the request finished
    func getPodcast(with uuid: UUID, completion: @escaping completion<PCKPodcast>)
    /// Search a Podcast by a given String
    ///
    /// - Parameters:
    ///   - string: The String to search for
    ///   - completion: The CompletionHandler called after the request finished
    func searchPodcasts(by string: String, completion: @escaping completion<[PCKPodcast]>)
    // MARK: - Global Actions
    /// Get the Top 100 Podcasts in Pocket Casts - Authentication is not required
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getTop100(completion: @escaping completion<[PCKPodcast]>)
    /// Get all featured Podcasts in Pocket Casts - Authentication is not required
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getFeatured(completion: @escaping completion<[PCKPodcast]>)
    /// Get all trending Podcasts in Pocket Casts - Authentication is not required
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getTrending(completion: @escaping completion<[PCKPodcast]>)
    /// Get all Categories and Countries available in Pocket Casts - Authentication is not required
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getCategoriesAndCountries(completion: @escaping completion<(categories: [PCKCategory], countries: [PCKCountry])>)
    /// Get all Networks available in Pocket Casts - Authentication is not required
    ///
    /// - Parameter completion: The CompletionHandler called after the request finished
    func getNetworks(completion: @escaping completion<[PCKNetwork]>)
    /// Get all Groups of specific Network - Authentication is not required
    ///
    /// - Parameters:
    ///   - networkId: The Id of the Network
    ///   - completion: The CompletionHandler called after the request finished
    func getNetworkGroups(networkId: Int, completion: @escaping completion<[PCKNetworkGroup]>)
    /// Get the Content (Array of PCKCategoryContent objects) of a Category for a specific Country - Authentication is not required
    ///
    /// - Parameters:
    ///   - categoryId: The Id of the category
    ///   - countryCode: The Code of the country
    ///   - completion: The CompletionHandler called after the request finished
    func getCategoryContent(categoryId: Int, countryCode: String, completion: @escaping completion<[PCKCategoryContent]>)
}
