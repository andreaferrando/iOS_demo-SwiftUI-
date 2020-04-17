//
//  UserResponseModel.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

struct UserResponseModel: Equatable, Codable {
    
    static func == (lhs: UserResponseModel, rhs: UserResponseModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var name: String
    var username: String
    var email: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case email
    }
    
    init(id: Int, name: String, username: String, email: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
    }

    func userViewModel() -> UserViewModel {
        return UserViewModel(user: self)
    }
}

struct UserViewModel {
    var id: Int
    var name: String
    var username: String
    var email: String
    
    init(user: UserResponseModel) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.email = user.email
    }
}
