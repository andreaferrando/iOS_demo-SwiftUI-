//
//  AlamofireManager.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import Combine

//
//enum APIServiceError: Error {
//  case parsing(description: String)
//  case network(description: String)
//}

//protocol APIRequestManager {
//     func request<T>(with components: URLComponents) -> AnyPublisher<T, APIServiceError> where T: Decodable
//}
//
//class DemoNSURLSessionManager: APIRequestManager {
//
//    private let session: URLSession = .shared
//
//    func request<T>(with components: URLComponents) -> AnyPublisher<T, APIServiceError> where T: Decodable {
//        guard let url = components.url else {
//            let error = APIServiceError.network(description: "Couldn't create URL")
//        return Fail(error: error).eraseToAnyPublisher()
//      }
//
//      return session.dataTaskPublisher(for: URLRequest(url: url))
//        .mapError { error in
//          APIServiceError.network(description: error.localizedDescription)
//        }
//        .map { post in
//            decode(post.data)
//        }
//        .eraseToAnyPublisher()
//    }
//}
