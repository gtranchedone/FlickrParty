//
//  PartyPhotosViewControllerTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import XCTest
import FlickrParty

class PartyPhotosViewControllerTests: XCTestCase {

    var viewController: PartyPhotosViewController?
    
    override func setUp() {
        super.setUp()
        self.viewController = PartyPhotosViewController()
    }
    
    override func tearDown() {
        self.viewController = nil
        super.tearDown()
    }
    
    func testViewControllerHasAppropriateTitleAfterViewDidLoad() {
        self.viewController?.view
        let actualTitle = self.viewController!.title
        XCTAssertEqual("Parties", actualTitle!, "PartyPhotosViewController doesn't have an appropriate title")
    }
    
}
