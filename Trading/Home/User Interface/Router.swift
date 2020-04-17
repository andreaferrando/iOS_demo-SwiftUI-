//
//  HomeRouter.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

class HomeRouter: HomePresenterToRouterProtocol {

    static func makePresenter() -> HomePresenter {
        let apiManager: HomeInteractorToAPIManagerProtocol = HomeAPIManager(config: Configuration())
        let localDataManager: HomeInteractorToLocalDataManagerProtocol = HomeLocalDataManager()
        let parseManager: HomeInteractorToParseManagerProtocol = HomeParser()
        
        let interactor = HomeInteractor(apiService: apiManager, localDataService: localDataManager, parseService: parseManager)
        let presenter = HomePresenter(interactor: interactor)

        return presenter 
    }

}
