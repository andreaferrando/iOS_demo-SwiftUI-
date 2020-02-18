//
//  HomeInteractor.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
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

    init(apiService: HomeInteractorToAPIManagerProtocol, localDataService: HomeInteractorToLocalDataManagerProtocol, parseService: HomeInteractorToParseManagerProtocol) {
        self.apiService = apiService
        self.localDataService = localDataService
        self.parseService = parseService
    }
}

extension HomeInteractor: HomeInteractorProtocol {

    //    func getPosts() -> AnyPublisher<[PostViewModel], Error> {
    //        let postsLocalData = localDataService.getPosts().tryCompactMap { postResponseModel in
    //            return postResponseModel.compactMap { $0.postViewModel() }
    //        }.eraseToAnyPublisher()
    //
    //
    //
    ////        self.dataActivityPublisher.send(postsLocalData)
    //
    //        let postsResponse = apiService.getPosts(page: 1, pageSize: 25)
    //        return postsResponse.tryCompactMap { postResponseModel in
    ////            self.localDataService.savePosts(postResponseModel)
    ////            self.dataActivityPublisher.send(postsLocalData)
    //            return postResponseModel.compactMap { $0.postViewModel() }
    //        }.eraseToAnyPublisher()
    //
    //
    ////        return AnyPublisher { subscriber in
    ////            subscriber.receive(completion: .finished)
    ////            subscriber.receive(completion: .failure(RESTClientError.error(error: err.localizedDescription)))
    ////        }
    //    }

    func getPosts() {

        _ = localDataService.getPosts().tryCompactMap { postResponseModel in
            return postResponseModel.compactMap { $0.postViewModel() }
        }.eraseToAnyPublisher().sink(receiveCompletion: { (error) in
//            callback(.failure(error))
        }) { (posts) in
           self.postsViewModel = posts
        }

//        _ = apiService.getPosts(page: 1, pageSize: 25).tryCompactMap { (postResponseModel) in
////            self.localDataService.savePosts(postResponseModel)
//            return postResponseModel.compactMap { $0.postViewModel() }
//        }.mapError({ (err) -> Error in
//            print("error:\(err)")
//            return err
//        }).eraseToAnyPublisher().sink(receiveCompletion: { (error) in
////            callback(.failure(Error(error)))
//            print("ERRORRRR")
//        }, receiveValue: { (posts) in
////            self.dataActivityPublisher.send(posts)
//            print("POSTS\(posts)")
//        })
    }

}
