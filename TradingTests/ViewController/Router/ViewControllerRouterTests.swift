//
//  HomeRouterTests.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import 

class HomeRouterTests: XCTestCase {

    private let router = HomeRouter()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateModule() {
        let mockNavC = UINavigationController(rootViewController: UIViewController(nibName: nil, bundle: nil))
        let vc = HomeRouter.createModule(using: mockNavC, withStoryboardId: "Main", identifier: "ViewControllerViewController")
        XCTAssertNotNil(vc)
        XCTAssertEqual(mockNavC, (vc!.presenter as? HomeRouterToPresenterProtocol)?.router?.navigationController)
        XCTAssertNotNil(HomeRouter.createModule(using: nil, withStoryboardId: "Main", identifier: "ViewControllerViewController"))
    }
    
}
