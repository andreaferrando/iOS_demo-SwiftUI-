//
//  HomeInteractor.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import Combine

final class HomeInteractor {
    var apiService: HomeInteractorToAPIManagerProtocol
    var localDataService: HomeInteractorToLocalDataManagerProtocol
    var parseService: HomeInteractorToParseManagerProtocol?

    @Published var postsViewModel = [PostViewModel]()
    var postsViewModelWrapper: Published<[PostViewModel]> {_postsViewModel }
    var _$postsViewModel: Published<[PostViewModel]>.Publisher { $postsViewModel }
    private var cancellableSet: Set<AnyCancellable> = []

    init(apiService: HomeInteractorToAPIManagerProtocol, localDataService: HomeInteractorToLocalDataManagerProtocol, parseService: HomeInteractorToParseManagerProtocol) {
        self.apiService = apiService
        self.localDataService = localDataService
        self.parseService = parseService
    }
}

extension HomeInteractor: HomeInteractorProtocol {

    func getPosts() {
        _ = localDataService.getPosts().tryCompactMap { postResponseModel in
            return postResponseModel.compactMap { $0.postViewModel() }
        }.eraseToAnyPublisher().sink(receiveCompletion: { _ in }) { (posts) in
           self.postsViewModel = posts
        }
        let apiData = apiService.getPosts(page: 1, pageSize: 25)
        apiData.tryCompactMap { (postResponseModel) in
            self.localDataService.savePosts(postResponseModel)
            return postResponseModel.compactMap { $0.postViewModel() }
        }.mapError({ (err) -> Error in
            print("error:\(err)")
            return err
        }).eraseToAnyPublisher().sink(receiveCompletion: { _ in }, receiveValue: { (posts) in
            self.postsViewModel = posts
        })
            .store(in: &cancellableSet)
    }

}
