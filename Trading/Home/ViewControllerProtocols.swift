//
//  ViewControllerProtocols.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import Foundation
import UIKit
import Combine

////Presenter calls, View listens. Presenter receives a reference from this protocol to access View. View conforms to the protocol
//protocol HomePresenterToViewProtocol: class {
//    var presenter: HomeViewToPresenterProtocol? { get set }
//
////    func showLoading(forceToStopAfter delay:Double)
////    func dismissLoading()
////    func showError(title: String, message: String)
//}

public enum ViewEvent {
    case viewAppears
    case viewDisappears
}

public enum HomeAction {
    case retry
}

//View calls, Presenter listens
protocol HomeViewToPresenterProtocol: class {
    func didReceiveEvent(_ event: ViewEvent)
    func didTriggerAction(_ action: HomeAction)

//   var posts: [PostViewModel]
   var postsWrapper: Published<[PostViewModel]> { get }
   var _$posts: Published<[PostViewModel]>.Publisher { get }

}

//Interactor calls, Presenter listens
protocol HomeInteractorToPresenterProtocol: class {
    var interactor: HomeInteractorProtocol? { get set }
    
}

//Presenter calls, Interactor listens
protocol HomeInteractorProtocol: class {
    var postsViewModel: [PostViewModel] {get set}
    var postsViewModelWrapper: Published<[PostViewModel]> { get }
    var _$postsViewModel: Published<[PostViewModel]>.Publisher { get }
    func getPosts()
}

//Presenter calls, Router listens
protocol HomePresenterToRouterProtocol: class {
    static func makePresenter() -> HomePresenter
}

//Router calls, Presenter listens
protocol HomeRouterToPresenterProtocol: class {
    var router: HomePresenterToRouterProtocol? { get set }
}

//APIManager calls, Interactor listens
protocol HomeAPIManagerToInteractorProtocol: class {
    var apiManager: HomeInteractorToAPIManagerProtocol? { get set }

    func getPosts(page: Int, pageSize: Int) -> AnyPublisher<[PostViewModel], Error>
}

//Interactor calls, APIManager listens
protocol HomeInteractorToAPIManagerProtocol: class {
   func getPosts(page: Int, pageSize: Int) -> AnyPublisher<[PostResponseModel], Error>
    
}

//LocalDataManager calls, Interactor listens
protocol HomeLocalDataManagerToInteractorProtocol: class {
    var localDataManager: HomeInteractorToLocalDataManagerProtocol? { get set }
    
}

//Interactor calls, LocalDataManager listens
protocol HomeInteractorToLocalDataManagerProtocol: class {
    func getPosts() -> AnyPublisher<[PostResponseModel], Error>
    func savePosts(_ posts: [PostResponseModel])
    
}

//ParseManager calls, Interactor listens
protocol HomeParseManagerToInteractorProtocol: class {
    var parseManager: HomeInteractorToParseManagerProtocol? { get set }
}

//Interactor calls, ParseManager listens
protocol HomeInteractorToParseManagerProtocol: class {
    
}
