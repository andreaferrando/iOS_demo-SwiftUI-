//
//  PostDetailsRouter.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

class PostDetailsRouter: PostDetailsPresenterToRouterProtocol {

    static func makePresenter(postId: Int) -> PostDetailsPresenter {
        let apiManager: PostDetailsInteractorToAPIManagerProtocol = PostDetailsAPIManager(config: Configuration())
        let localDataManager: PostDetailsInteractorToLocalDataManagerProtocol = PostDetailsLocalDataManager()
        let parseManager: PostDetailsInteractorToParseManagerProtocol = PostDetailsParser()
        
        let interactor = PostDetailsInteractor(apiService: apiManager, localDataService: localDataManager, parseService: parseManager)
        let presenter = PostDetailsPresenter(interactor: interactor, postId: postId)

        return presenter 
    }

}
