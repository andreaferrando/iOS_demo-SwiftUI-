//
//  HomeLocalDataManagerTests.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import XCTest
@testable import 

class HomeLocalDataManagerTests: XCTestCase {
    
    private var localDataManager: HomeInteractorToLocalDataManagerProtocol!
    
    override func setUp() {
        super.setUp()
//        localDataManager = HomeLocalDataManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //recommend to deleteAllData before starting a new test, to make the tests completely independent between each other
        super.tearDown()
    }
    
}
