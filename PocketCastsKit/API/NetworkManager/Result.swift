//
//  Result.swift
//  PocketCastsKit
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

/// The Result of a Request
///
/// - success: Success case if the Request was successfull
/// - error: Error caste if the Request failed
public enum Result<T> {
    case success(T)
    case error(Error)
}
