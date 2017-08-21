//
//  PCKClient.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

private let baseURLString = "https://play.pocketcasts.com"
private let staticBaseURLString = "https://static.pocketcasts.com"

// Defined CharacterSet matches urlencoded as needed
extension CharacterSet {
    static let urlEncoded = CharacterSet(charactersIn: "!*'();:@+$,/?%#[] ").inverted
}

public enum PCKClientError: Error {
    case bodyDataBuildingFailed
    case invalidResponse(data: Data?)
    case invalidCredentials
    case updateStarredDidFail
    case updatePlayingStatusDidFail
    case updatePositionDidFail
    case subscribeDidFail
}

private struct EpisodeContainer: Decodable {
    let episodes: [PCKEpisode]
    let total: Int?
}

private struct PodcastContainer: Decodable {
    let podcasts: [PCKPodcast]
}
private struct ResultContainer: Decodable {
    let status: String
}

private struct GlobalPodcastContainer: Decodable {
    let status: String
    let result: PodcastContainer
}

private struct GlobalEpisodeContainer: Decodable {
    let status: String
    let result: EpisodeContainer
}

private struct showNotesContainer: Decodable {
    let show_notes: String
}

private struct SingleEpisodeContainer: Decodable {
    let episode: PCKEpisode
}

private struct SinglePodcastContainer: Decodable {
    let podcast: PCKPodcast
}

public struct PCKClient {
    public static let shared = PCKClient()
    
    private let client: RestClient
    private let globalClient: RestClient
    
    internal init(client: RestClient = try! RestClient(baseURLString: baseURLString),
                  globalClient: RestClient = try! RestClient(baseURLString: staticBaseURLString)) {
        self.client = client
        self.globalClient = globalClient
    }
}

//MARK: - Response handling
extension PCKClient {
    private func handleResponse<T>(response: Result<(Data, HTTPURLResponse)>,
                                   completion: completion<T>,
                                   successHandler: ((_ data: Data, _ response: HTTPURLResponse)  -> Void)) {
        switch response {
        case .error(let error):
            completion(Result.error(error))
        case .success(let response):
            successHandler(response.0, response.1)
        }
    }
    
    private func parseBodyDictionary(dict: [String: String]) -> Data? {
        var string = ""
        
        for k in dict.keys {
            let val = dict[k]!
            string += "\(k)=\(val)&"
        }
        string.removeLast()
        
        guard let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlEncoded) else {
            return nil
        }
        return encoded.data(using: .utf8)
    }
}


extension PCKClient: PCKClientProtocol {
    // MARK: - Global Interaction
    public func getTrending(completion: @escaping ((Result<[PCKPodcast]>) -> Void)) {
        globalClient.get(path: "/discover/json/trending.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: GlobalPodcastContainer.self) {
                    if !(container.status == "ok") {
                        completion(Result.error(PCKClientError.invalidResponse(data: data)))
                        return
                    }
                    completion(Result.success(container.result.podcasts))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    
    public func getFeatured(completion: @escaping ((Result<[PCKPodcast]>) -> Void)) {
        globalClient.get(path: "/discover/json/featured.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: GlobalPodcastContainer.self) {
                    if !(container.status == "ok") {
                        completion(Result.error(PCKClientError.invalidResponse(data: data)))
                        return
                    }
                    completion(Result.success(container.result.podcasts))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func getTop100(completion: @escaping ((Result<[PCKPodcast]>) -> Void)) {
        globalClient.get(path: "/discover/json/popular_world.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: GlobalPodcastContainer.self) {
                    if !(container.status == "ok") {
                        completion(Result.error(PCKClientError.invalidResponse(data: data)))
                        return
                    }
                    completion(Result.success(container.result.podcasts))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    // MARK: - Podcast Interaction
    public func getPodcast(with uuid: UUID, completion: @escaping ((Result<PCKPodcast>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "uuid": uuid.uuidString
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/podcasts/podcast.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, _) in
                if let container = JSONParser.shared.decode(data, type: SinglePodcastContainer.self) {
                    completion(Result.success(container.podcast))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func getEpisodes(for podcast: UUID,
                            page: Int = 1,
                            order: SortOrder = .descending,
                            completion: @escaping ((Result<(episodes:[PCKEpisode], order: SortOrder, nextPage: Int)>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "uuid": podcast.uuidString,
            "page": "\(page)",
            "sort": "\(order.rawValue)"
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/episodes/find_by_podcast.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, _) in
                if let container = JSONParser.shared.decode(data, type: GlobalEpisodeContainer.self) {
                    guard let total = container.result.total else {
                        completion(Result.error(PCKClientError.invalidResponse(data: data)))
                        return
                    }
                    let hasMore = total > container.result.episodes.count
                    let next = hasMore ? page+1 : page
                    completion(Result.success((episodes: container.result.episodes, order: order, nextPage: next)))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func unsubscribe(podcast: UUID, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "uuid": podcast.uuidString
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/podcasts/unsubscribe.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: ResultContainer.self) {
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.subscribeDidFail)
                    completion(result)
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func subscribe(podcast: UUID, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "uuid": podcast.uuidString
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/podcasts/subscribe.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: ResultContainer.self) {
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.subscribeDidFail)
                    completion(result)
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    // MARK: Episode Interaction
    public func getEpisode(with uuid: UUID, of podcast: UUID, completion: @escaping ((Result<PCKEpisode>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "uuid": podcast.uuidString,
            "episode_uuid": uuid.uuidString
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/podcasts/podcast.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, _) in
                if let container = JSONParser.shared.decode(data, type: SingleEpisodeContainer.self) {
                    completion(Result.success(container.episode))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func getShowNotes(for episode: UUID, completion: @escaping ((Result<String>) -> Void)) {
        guard let data = JSONParser.shared.encode(dictionary: [
            "uuid": episode.uuidString
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/episodes/show_notes.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, _) in
                if let container = JSONParser.shared.decode(data, type: showNotesContainer.self) {
                    completion(Result.success(container.show_notes))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func setPlayingPosition(for episode: UUID, podcast: UUID, position: Int, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = JSONParser.shared.encode(dictionary: [
            "uuid": episode.uuidString,
            "podcast_uuid": podcast.uuidString,
            "playing_status": 2,
            "played_up_to": position
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let body = RequestOption.bodyData(data: data)
        let header = RequestOption.headerField([("Content-Type", "application/json")])
        client.post(path: "/web/episodes/update_episode_position.json", options: [body, header]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: ResultContainer.self) {
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.updatePositionDidFail)
                    completion(result)
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func setPlayingStatus(for episode: UUID, podcast: UUID, status: PlayingStatus, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "playing_status": "\(status.rawValue)",
            "uuid": episode.uuidString,
            "podcast_uuid": podcast.uuidString
            ]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        client.post(path: "/web/episodes/update_episode_position.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: ResultContainer.self) {
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.updatePlayingStatusDidFail)
                    completion(result)
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func setStarred(for episode: UUID, podcast: UUID, starred: Bool, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = parseBodyDictionary(dict: [
            "starred" : (starred) ? "1" : "0",
            "podcast_uuid": podcast.uuidString,
            "uuid": episode.uuidString]) else {
                completion(Result.error(PCKClientError.bodyDataBuildingFailed))
                return
        }
        let option = RequestOption.bodyData(data: data)
        
        client.post(path: "/web/episodes/update_episode_star.json", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: ResultContainer.self) {
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.updateStarredDidFail)
                    completion(result)
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }    
    
    // MARK: - Authentication
    public func authenticate(username: String, password: String, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = parseBodyDictionary(dict: ["[user]email": username,"[user]password": password]) else {
            completion(Result.error(PCKClientError.bodyDataBuildingFailed))
            return
        }
        let option = RequestOption.bodyData(data: data)
        
        client.post(path: "/users/sign_in", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                
                if response.url == URL(string: "https://play.pocketcasts.com/web/podcasts/index") {
                    completion(Result.success(true))
                } else {
                    completion(Result.error(PCKClientError.invalidCredentials))
                }
            })
        }
    }
    
    public func isAuthenticated(completion: @escaping ((Result<Bool>) -> Void)) {
        client.get(path: "/", options: []) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if response.url == URL(string: "https://play.pocketcasts.com/web/podcasts/index") {
                    completion(Result.success(true))
                } else {
                    completion(Result.error(PCKClientError.invalidCredentials))
                }
            })
        }
    }
    
    // MARK: - User Podcast feeds
    public func getStarredEpisodes(completion: @escaping ((Result<[PCKEpisode]>) -> Void)) {
        client.post(path: "/web/episodes/starred_episodes.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: EpisodeContainer.self) {
                    completion(Result.success(container.episodes))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func getNewEpisodes(completion: @escaping ((Result<[PCKEpisode]>) -> Void)) {
        client.post(path: "/web/episodes/new_releases_episodes.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: EpisodeContainer.self) {
                    completion(Result.success(container.episodes))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func getEpisodesInProgress(completion: @escaping ((Result<[PCKEpisode]>) -> Void)) {
        client.post(path: "/web/episodes/in_progress_episodes.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: EpisodeContainer.self) {
                    completion(Result.success(container.episodes))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    public func getSubscriptions(completion: @escaping ((Result<[PCKPodcast]>) -> Void)) {
        client.post(path: "/web/podcasts/all.json") { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                if let container = JSONParser.shared.decode(data, type: PodcastContainer.self) {
                    completion(Result.success(container.podcasts))
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
}



