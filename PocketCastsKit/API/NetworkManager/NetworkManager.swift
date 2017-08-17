//
//  NetworkManager.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

enum NetworkManagerErrors: Error {
    case canNotBuildRequest
    case invalidResponse
    case noSuccessResponse(statusCode: Int, data: Data)
}
struct NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    
    internal init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func makeRequest(url: URL, options: [RequestOption], method: MethodType, completion: @escaping ((Result<Data>) -> Void)) {
        guard let request = getRequest(for: url, options: options, method: method) else {
            completion(Result.error(NetworkManagerErrors.canNotBuildRequest))
            return
        }
        session.dataTask(with: request) { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ((Result<Data>) -> Void)) {
        if let error = error {
            completion(Result.error(error))
            return
        }
        
        guard let data = data, let response = response as? HTTPURLResponse else {
            completion(Result.error(NetworkManagerErrors.invalidResponse))
            return
        }
        
        if !(200...299 ~= response.statusCode) {
            completion(Result.error(NetworkManagerErrors.noSuccessResponse(statusCode: response.statusCode, data: data)))
            return
        }
        completion(Result.success(data))

    }
    
    private func getRequest(for url: URL, options: [RequestOption], method: MethodType ) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for o in  options {
            switch o {
            case .headerField(let pairs):
                for kv in pairs {
                    request.addValue(kv.value, forHTTPHeaderField: kv.key)
                }
            case .bodyData(let data):
                request.httpBody = data
            case .urlParameter(let params):
                var queryItems = [URLQueryItem]()
                
                for key in params.keys {
                    queryItems.append(URLQueryItem(name: key, value: params[key] as? String))
                }
                guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    return nil
                }
                
                components.queryItems = queryItems
                request.url = components.url
            }
        }
        return request
    }
}
