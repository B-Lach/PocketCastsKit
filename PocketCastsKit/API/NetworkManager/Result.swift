//
//  Result.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case error(Error)
}
