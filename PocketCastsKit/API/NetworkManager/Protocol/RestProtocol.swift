//
//  RestProtocol.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

protocol RestProtocol {
    func get(path: String, options: [RequestOption], completion: @escaping completion<(Data, HTTPURLResponse)>)
    func post(path: String, options: [RequestOption], completion: @escaping completion<(Data, HTTPURLResponse)>)
}
