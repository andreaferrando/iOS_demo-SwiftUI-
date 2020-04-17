//
//  PostDetailsAPIManager.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import Combine

//https://heckj.github.io/swiftui-notes/#coreconcepts-publisher-subscriber

class PostDetailsAPIManager: PostDetailsInteractorToAPIManagerProtocol {
    
    private let session: URLSession = .shared

    var config: ConfigurationDelegate

    init(config: ConfigurationDelegate) {
        self.config = config
    }

    private lazy var url: URL = {
        return URL(string: self.config.baseUrl)!
    }()
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()

    func getComments(postId: Int) -> AnyPublisher<[CommentResponseModel], Error> {
        if config.isMock() {
            return getCommentsMock(postId: postId)
        }
        let request = URLRequest(url: URL(string: "\(self.config.baseUrl)/\(ApiEndPoints.comments)?postId=\(postId)")!)

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { (arg) in
                let (data, response) = arg
                do {
                    try API.mapResponseError(response)
                    return data
                }
        }
        .decode(type: [CommentResponseModel].self, decoder: jsonDecoder)
        .mapError { error in
            return API.mapError(error)
        }
        .eraseToAnyPublisher()
    }

    func getUser(_ id: Int) -> AnyPublisher<UserResponseModel, Error> {
        if config.isMock() {
            return getUserMock(id)
        }
        let request = URLRequest(url: URL(string: "\(self.config.baseUrl)/\(ApiEndPoints.users)/\(id)")!)

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { (arg) in
                let (data, response) = arg
                do {
                    try API.mapResponseError(response)
                    return data
                }
        }
        .decode(type: UserResponseModel.self, decoder: jsonDecoder)
        .mapError { error in
            return API.mapError(error)
        }
        .eraseToAnyPublisher()
    }

    func getPost(_ id: Int) -> AnyPublisher<PostResponseModel, Error> {
        if config.isMock() {
            return getPostMock(id)
        }
        let request = URLRequest(url: URL(string: "\(self.config.baseUrl)/\(ApiEndPoints.posts)/\(id)")!)

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { (arg) in
                let (data, response) = arg
                do {
                    try API.mapResponseError(response)
                    return data
                }
        }
        .decode(type: PostResponseModel.self, decoder: jsonDecoder)
        .mapError { error in
            return API.mapError(error)
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Mock
    private func getCommentsMock(postId: Int) -> AnyPublisher<[CommentResponseModel], Error> {
        guard let data = JsonManager.retrieveDataJsonFileFromBundle(fileName: "Comments") else {
            return Fail(error: APIServiceError.api(reason: "Couldn't find JSON data")).eraseToAnyPublisher()
        }
        return Just(data)
            .map { $0 }
            .decode(type: [CommentResponseModel].self, decoder: jsonDecoder)
            .map({ (comments) -> [CommentResponseModel] in
                return comments.filter { $0.postId == postId }
            })
            .eraseToAnyPublisher()
    }

    private func getUserMock(_ id: Int) -> AnyPublisher<UserResponseModel, Error> {
        guard let data = JsonManager.retrieveDataJsonFileFromBundle(fileName: "Users") else {
            return Fail(error: APIServiceError.api(reason: "Couldn't find JSON data")).eraseToAnyPublisher()
        }
        return Just(data)
            .map { $0 }
            .decode(type: [UserResponseModel].self, decoder: jsonDecoder)
            .map({ (users) -> UserResponseModel in
                return users.filter { $0.id == id }.first ?? UserResponseModel(id: 0, name: "", username: "", email: "")
            })
            .eraseToAnyPublisher()
    }

    private func getPostMock(_ id: Int) -> AnyPublisher<PostResponseModel, Error> {
        guard let data = JsonManager.retrieveDataJsonFileFromBundle(fileName: "Posts") else {
            return Fail(error: APIServiceError.api(reason: "Couldn't find JSON data")).eraseToAnyPublisher()
        }
        return Just(data)
            .map { $0 }
            .decode(type: [PostResponseModel].self, decoder: jsonDecoder)
            .map({ (posts) -> PostResponseModel in
                return posts.filter { $0.id == id }.first ?? PostResponseModel(id: 1, userId: 1, title: "", body: "")
            })
            .eraseToAnyPublisher()
    }
}
