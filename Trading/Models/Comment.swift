//
//  CommentResponseModel.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

struct CommentResponseModel: Equatable, Codable {
    
    static func == (lhs: CommentResponseModel, rhs: CommentResponseModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var postId: Int
    var name: String
    var email: String
    var body: String
    
    init(id: Int, postId: Int, name: String, email: String, body: String) {
        self.id = id
        self.postId = postId
        self.name = name
        self.body = body
        self.email = email
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case postId
        case name
        case email
        case body
    }

    func commentViewModel() -> CommentViewModel {
        return CommentViewModel(comment: self)
    }

}

struct CommentViewModel: Codable {
    var id: Int
    var title: String
    var author: String
    var body: String
    
    init(comment: CommentResponseModel) {
//        JSONDecoder().decode(CommentViewModel.self, from: Data(from: comment))
        self.id = comment.id
        self.title = comment.name
        self.author = comment.email
        self.body = comment.body
    }
}
