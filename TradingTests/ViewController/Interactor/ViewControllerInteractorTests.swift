//
//  HomeInteractorTests.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import 

class HomeInteractorTests: XCTestCase {

    private let interactor = HomeInteractor()
    private let presenter = MockPresenter()
    private let apiManager = MockAPIManager()
    private let localDataManager = MockLocalDataManager()
    private let parser = HomeParser()
    
    override func setUp() {
        super.setUp()
        interactor.presenter = presenter
        interactor.apiManager = apiManager
        apiManager.interactor = interactor
        interactor.localDataManager = localDataManager
        localDataManager.interactor = interactor
        interactor.parseManager = parser
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockPresenter: HomeInteractorToPresenterProtocol {
        var interactor: HomePresenterToInteractorProtocol?
        
    }
    
    class MockAPIManager: HomeInteractorToAPIManagerProtocol {
        var interactor: HomeAPIManagerToInteractorProtocol?
        
    }
    
    class MockLocalDataManager: HomeInteractorToLocalDataManagerProtocol {
        var interactor: HomeLocalDataManagerToInteractorProtocol?
        
    }
    
}
