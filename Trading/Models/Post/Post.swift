//
//  ViewControllerItem.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import Foundation

struct PostResponseModel: Hashable, Codable, StructDecoder {
    static var EntityName: String = "Post"

    var id: Int
    var userId: Int
    var title: String
    var body: String

    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }

    private enum CodingKeys: String, CodingKey {
       case id
       case userId
       case title
       case body
   }

    func postViewModel() -> PostViewModel {
        return PostViewModel(post: self)
    }

}

struct PostViewModel: Equatable, StructDecoder {
    static var EntityName: String = "Post"

    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    var id: Int
    var author: String
    var title: String
    var body: String

    init(post: PostResponseModel) {
        self.id = post.id
        self.author = "aaaa"
        self.title = post.title
        self.body = post.body
    }
}

import CoreData

extension Post {

    func postResponseModel() -> PostResponseModel {
        return PostResponseModel(id: Int(self.id), userId: Int(self.userId), title: self.title ?? "", body: self.body ?? "")
    }
}














