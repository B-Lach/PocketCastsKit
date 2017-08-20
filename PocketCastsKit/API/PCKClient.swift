//
//  PCKClient.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

private let baseURLString = "https://play.pocketcasts.com"

// Defined CharacterSet matches urlencoded as needed
extension CharacterSet {
    static let urlEncoded = CharacterSet(charactersIn: "!*'();:@+$,/?%#[] ").inverted
}

public enum PCKClientError: Error {
    case bodyDataBuildingFailed
    case invalidResponse(data: Data?)
    case invalidCredentials
    case updateStarredFailed
}

private struct EpisodeContainer: Decodable {
    let episodes: [PCKEpisode]
}

private struct PodcastContainer: Decodable {
    let podcasts: [PCKPodcast]
}
private struct ResultContainer: Decodable {
    let status: String
}

public struct PCKClient {
    static let shared = PCKClient()
    
    private let client: RestClient
    
    internal init(client: RestClient = try! RestClient(baseURLString: baseURLString)) {
        self.client = client
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
    func setPlayingStatus(for episode: UUID, podcast: UUID, status: PlayingStatus, completion: @escaping completion<Bool>) {
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
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.updateStarredFailed)
                    completion(result)
                } else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                }
            })
        }
    }
    
    func setStarred(for episode: UUID, podcast: UUID, starred: Bool, completion: @escaping ((Result<Bool>) -> Void)) {
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
                    let result: Result = container.status == "ok" ? .success(true) : .error(PCKClientError.updateStarredFailed)
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
    func getStarredEpisodes(completion: @escaping ((Result<[PCKEpisode]>) -> Void)) {
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
    
    func getNewEpisodes(completion: @escaping ((Result<[PCKEpisode]>) -> Void)) {
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
    
    func getEpisodesInProgress(completion: @escaping ((Result<[PCKEpisode]>) -> Void)) {
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
    
    func getSubscriptions(completion: @escaping ((Result<[PCKPodcast]>) -> Void)) {
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



