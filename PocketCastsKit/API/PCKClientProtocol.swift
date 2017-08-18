//
//  PCKClientProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 18.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

protocol PCKClientProtocol {
    // MARK: - Authentication
    func authenticate(username: String, password: String, completion: @escaping completion<Bool>)
    func isAuthenticated(completion: @escaping completion<Bool>)
}
