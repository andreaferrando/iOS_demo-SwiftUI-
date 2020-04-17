//
//  ViewControllerProtocols.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit
import Combine

//View calls, Presenter listens
protocol PostDetailsViewToPresenterProtocol: class {
    func didReceiveEvent(_ event: ViewEvent)

    var postId: Int { get set }

    //   var post: PostViewModel { get set }
    var postWrapper: Published<PostDetailViewModel> { get }
    var _$post: Published<PostDetailViewModel>.Publisher { get }

}

//Interactor calls, Presenter listens
protocol PostDetailsInteractorToPresenterProtocol: class {
    var interactor: PostDetailsInteractorProtocol? { get set }
    
}

//Presenter calls, Interactor listens
protocol PostDetailsInteractorProtocol: class {
    var post: PostDetailViewModel {get set}
    var postWrapper: Published<PostDetailViewModel> { get }
    var _$post: Published<PostDetailViewModel>.Publisher { get }

    func getPostDetails(postId: Int)
}

//Presenter calls, Router listens
protocol PostDetailsPresenterToRouterProtocol: class {
    static func makePresenter(postId: Int) -> PostDetailsPresenter
}

//Router calls, Presenter listens
protocol PostDetailsRouterToPresenterProtocol: class {
    var router: PostDetailsPresenterToRouterProtocol? { get set }
}

//APIManager calls, Interactor listens
protocol PostDetailsAPIManagerToInteractorProtocol: class {
    var apiManager: PostDetailsInteractorToAPIManagerProtocol? { get set }

}

//Interactor calls, APIManager listens
protocol PostDetailsInteractorToAPIManagerProtocol: class {
    func getComments(postId: Int) -> AnyPublisher<[CommentResponseModel], Error>
    func getUser(_ id: Int) -> AnyPublisher<UserResponseModel, Error>
    func getPost(_ id: Int) -> AnyPublisher<PostResponseModel, Error>
}

//LocalDataManager calls, Interactor listens
protocol PostDetailsLocalDataManagerToInteractorProtocol: class {
    var localDataManager: PostDetailsInteractorToLocalDataManagerProtocol? { get set }
    
}

//Interactor calls, LocalDataManager listens
protocol PostDetailsInteractorToLocalDataManagerProtocol: class {
    func getPosts() -> AnyPublisher<[PostResponseModel], Error>
    func savePosts(_ posts: [PostResponseModel])
    
}

//ParseManager calls, Interactor listens
protocol PostDetailsParseManagerToInteractorProtocol: class {
    var parseManager: PostDetailsInteractorToParseManagerProtocol? { get set }
}

//Interactor calls, ParseManager listens
protocol PostDetailsInteractorToParseManagerProtocol: class {
    
}
