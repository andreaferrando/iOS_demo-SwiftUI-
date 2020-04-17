//
//  API+Utils.swift
//  Trading
//
//  Created by Ferrando, Andrea
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation

enum LocalDataServiceError: Error {
  case parsing(description: String)
  case fetch(description: String)
}

enum APIServiceError: Error, LocalizedError {
    case unknown, api(reason: String), parsing(reason: String), network(from: URLError)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .api(let reason), .parsing(let reason):
            return reason
        case .network(let from):
            return from.localizedDescription
        }
    }
}
