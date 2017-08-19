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

// MARK: - Authentication
extension PCKClient: PCKClientProtocol {
    
    public func authenticate(username: String, password: String, completion: @escaping ((Result<Bool>) -> Void)) {
        guard let data = parseBodyDictionary(dict: ["[user]email": username,"[user]password": password]) else {
            completion(Result.error(PCKClientError.bodyDataBuildingFailed))
            return
        }
        let option = RequestOption.bodyData(data: data)
        
        client.post(path: "/users/sign_in", options: [option]) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                
                guard let htmlString = String(data: data, encoding: .utf8) else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                    return
                }
                
                if !htmlString.contains("var USER_PODCASTS_UUIDS") {
                    completion(Result.error(PCKClientError.invalidCredentials))
                    return
                }
                completion(Result.success(true))
            })
        }
    }
    
    public func isAuthenticated(completion: @escaping ((Result<Bool>) -> Void)) {
        client.get(path: "/", options: []) { (result) in
            self.handleResponse(response: result, completion: completion, successHandler: { (data, response) in
                guard let htmlString = String(data: data, encoding: .utf8) else {
                    completion(Result.error(PCKClientError.invalidResponse(data: data)))
                    return
                }
                completion(Result.success(htmlString.contains("var USER_PODCASTS_UUIDS")))
            })
        }
    }
}
