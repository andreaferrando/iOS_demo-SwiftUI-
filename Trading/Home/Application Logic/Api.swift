//
//  HomeAPIManager.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import Foundation
import Combine
//https://heckj.github.io/swiftui-notes/#coreconcepts-publisher-subscriber
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

class HomeAPIManager: HomeInteractorToAPIManagerProtocol {
    
    private let session: URLSession = .shared

    var config: ConfigurationDelegate

    init(config: ConfigurationDelegate) {
        self.config = config
    }

    private lazy var url: URL = {
        return URL(string: self.config.baseUrl+"/posts")!
    }()
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()

    func getPosts(page: Int, pageSize: Int) -> AnyPublisher<[PostResponseModel], Error> {
        if config.isMock() {
           return getPostsMock()
        }

        let request = URLRequest(url: url)

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
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
                return data
            }
            .decode(type: [PostResponseModel].self, decoder: jsonDecoder)
            .mapError { error in
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
            .eraseToAnyPublisher()
    }

    private func getPostsMock() -> AnyPublisher<[PostResponseModel], Error> {
        guard let data = JsonManager.retrieveDataJsonFileFromBundle(fileName: "Posts") else {
            return Fail(error: APIServiceError.api(reason: "Couldn't find JSON data")).eraseToAnyPublisher()
        }
        return Just(data)
        .map { $0 }
        .decode(type: [PostResponseModel].self, decoder: jsonDecoder)
        .eraseToAnyPublisher()
    }

}
