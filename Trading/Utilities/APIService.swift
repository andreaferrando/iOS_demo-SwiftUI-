//
//  AlamofireManager.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import Combine

struct API {
    static func mapResponseError(_ response: Any) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIServiceError.unknown
        }
        if httpResponse.statusCode == 401 {
            throw APIServiceError.api(reason: "Unauthorized")
        }
        if httpResponse.statusCode == 403 {
            throw APIServiceError.api(reason: "Resource forbidden")
        }
        if httpResponse.statusCode == 404 {
            throw APIServiceError.api(reason: "Resource not found")
        }
        if 405..<500 ~= httpResponse.statusCode {
            throw APIServiceError.api(reason: "client error")
        }
        if 500..<600 ~= httpResponse.statusCode {
            throw APIServiceError.api(reason: "server error")
        }
    }

    static func mapError(_ error: Any) -> APIServiceError {
        // if it's our kind of error already, we can return it directly
        if let error = error as? APIServiceError {
            return error
        }
        // if it is a URLError, we can convert it into our more general error kind
        if let urlerror = error as? URLError {
            return APIServiceError.network(from: urlerror)
        }
        // if all else fails, return the unknown error condition
        return APIServiceError.unknown
    }
}
