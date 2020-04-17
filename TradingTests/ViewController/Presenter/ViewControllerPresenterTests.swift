//
//  HomePresenterTests.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import 

class HomePresenterTest: XCTestCase {

    private let presenter = HomePresenter()
    private let interactor = MockInteractor()
    private let router = MockRouter()
    private let view = MockViewController()
    
    override func setUp() {
        super.setUp()
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class MockInteractor: HomePresenterToInteractorProtocol {
        var presenter: HomeInteractorToPresenterProtocol?
    }
    
    class MockRouter: HomePresenterToRouterProtocol {

    }

    class MockViewController: HomePresenterToViewProtocol {
//        var presenter: HomeViewToPresenterProtocol?
//
//        var didShowLoading = false
//        var didDismissLoading = false
//        var didShowError = false
//
//        func showLoading(forceToStopAfter delay: Double) {
//            didShowLoading = true
//        }
//
//        func dismissLoading() {
//            didDismissLoading = true
//        }
//
//        func showError(title: String, message: String) {
//            didShowError = true
//        }

    }
    
}
