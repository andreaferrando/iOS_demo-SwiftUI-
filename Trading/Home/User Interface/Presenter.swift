//
//  HomePresenter.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import Foundation
import Combine

class HomePresenter: ObservableObject {
    
    var interactor: HomeInteractorProtocol
    var router: HomePresenterToRouterProtocol?

    @Published var posts: [PostViewModel]
    var postsWrapper: Published<[PostViewModel]> {_posts }
    var _$posts: Published<[PostViewModel]>.Publisher { $posts }

    private var postsCancellable: AnyCancellable?

    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
        self.posts = []
        self.setPostsSubscriber()
    }
    
}

extension HomePresenter: HomeViewToPresenterProtocol {

    func didReceiveEvent(_ event: ViewEvent) {
        switch event {
        case .viewAppears:
            getPosts()
        case .viewDisappears:
            postsCancellable?.cancel()
        }
    }
    func didTriggerAction(_ action: HomeAction) {
        switch action {
        case .retry:
            getPosts()
        }
    }
}

extension HomePresenter {

    private func setPostsSubscriber() {
        postsCancellable = self.interactor._$postsViewModel
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print("COMPLETION")
                switch completion {
                case .failure(let error):
                    print("ERROR \(error)")
                case .finished:
                    break
                }
            }) { postsViewModel in
                print("postsViewModel",postsViewModel)
                self.posts = postsViewModel
        }
    }

    func getPosts() {
        interactor.getPosts()

//        postsCancellable = interactor.getPosts()
//        .receive(on: RunLoop.main)
//        .sink(receiveCompletion: { completion in
//            print("COMPLETION")
//            switch completion {
//            case .failure(let error):
//                print("ERROR \(error)")
//            case .finished:
//                break
//            }
//        }) { postsViewModel in
//            print("postsViewModel",postsViewModel)
//            self.posts = postsViewModel
//        }
    }
}
