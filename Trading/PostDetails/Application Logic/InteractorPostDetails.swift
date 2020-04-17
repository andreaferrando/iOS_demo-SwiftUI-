//
//  PostDetailsInteractor.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import Combine

final class PostDetailsInteractor {
    var apiService: PostDetailsInteractorToAPIManagerProtocol
    var localDataService: PostDetailsInteractorToLocalDataManagerProtocol
    var parseService: PostDetailsInteractorToParseManagerProtocol?

    @Published var post = PostDetailViewModel(author: "", title: "", body: "", comments: [])
    var postWrapper: Published<PostDetailViewModel> {_post }
    var _$post: Published<PostDetailViewModel>.Publisher { $post }
    private var cancellableSet: Set<AnyCancellable> = []

    init(apiService: PostDetailsInteractorToAPIManagerProtocol, localDataService: PostDetailsInteractorToLocalDataManagerProtocol, parseService: PostDetailsInteractorToParseManagerProtocol) {
        self.apiService = apiService
        self.localDataService = localDataService
        self.parseService = parseService
    }
}

extension PostDetailsInteractor: PostDetailsInteractorProtocol {

    func getPostDetails(postId: Int) {
        let publisher1 = self.apiService.getComments(postId: postId).tryCompactMap { (commentResponseModel) in
            return commentResponseModel.compactMap { $0.commentViewModel() }
        }.mapError({ (err) -> Error in
            print("error:\(err)")
            return err
        }).eraseToAnyPublisher()

        let publisher2 = self.apiService.getPost(postId)
            .map { $0.postViewModel()}
            .mapError({ (err) -> Error in
                print("error:\(err)")
                return err
            })
            .eraseToAnyPublisher()

        _ = Publishers.Zip(publisher1, publisher2).sink(receiveCompletion: { _ in
        }, receiveValue: { (arg) in
            let (comments, post) = arg
            self.apiService.getUser(post.id)
                .map { $0.userViewModel() }
                .mapError({ (err) -> Error in
                    return err
                }).sink(receiveCompletion: { _ in
                }) { (user) in
                    self.post = PostDetailViewModel(author: user.username, title: post.title, body: post.body, comments: comments)
            }
        }).store(in: &self.cancellableSet)
        
//        Publishers.Zip(zip1, publisher3)
//            .tryMap({ (arg0) -> PostDetailViewModel in
//                let (comments, post) = arg0.0
//                let user = arg0.1
//                return PostDetailViewModel(author: user.username, title: post.title, body: post.body, comments: comments)
//            })
//            .sink(receiveCompletion: { (completion) in
//                print("COPML")
//            }, receiveValue: { (post) in
//                print("pppp \(post)")
//                self.post = post
//            }).store(in: &self.cancellableSet)
    }

}
