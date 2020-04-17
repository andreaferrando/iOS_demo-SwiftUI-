//
//  PostDetailsPostDetails.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import Combine

class PostDetailsPresenter: ObservableObject {
    
    var interactor: PostDetailsInteractorProtocol
    var router: PostDetailsPresenterToRouterProtocol?
    var postId: Int

    @Published var post: PostDetailViewModel
    var postWrapper: Published<PostDetailViewModel> {_post }
    var _$post: Published<PostDetailViewModel>.Publisher { $post }

    private var postCancellable: AnyCancellable?

    init(interactor: PostDetailsInteractorProtocol, postId: Int) {
        self.interactor = interactor
        self.post = PostDetailViewModel(author: "", title: "", body: "", comments: [])
        self.postId = postId
        self.setPostSubscriber()
    }
    
}

extension PostDetailsPresenter: PostDetailsViewToPresenterProtocol {

    func didReceiveEvent(_ event: ViewEvent) {
        switch event {
        case .viewAppears:
            getPost()
        case .viewDisappears:
            postCancellable?.cancel()
        }
    }
}

extension PostDetailsPresenter {

    private func setPostSubscriber() {
        postCancellable = self.interactor._$post
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("error \(error)")
                case .finished:
                    break
                }
            }) { post in
                self.post = post
        }
    }

    func getPost() {
        interactor.getPostDetails(postId: postId)
    }

}
