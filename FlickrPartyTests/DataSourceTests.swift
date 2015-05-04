//
//  DataSourceTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class DataSourceTests: XCTestCase {

    var dataSource: ViewDataSource?
    
    override func setUp() {
        super.setUp()
        dataSource = ViewDataSource()
    }
    
    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    func testReturnsNoItemsByDefault() {
        XCTAssertEqual(dataSource!.numberOfItems(), 0, "DataSource isn't returning the right number of items")
    }

    func testReturnsNoSectionsByDefault() {
        XCTAssertEqual(dataSource!.numberOfSections(), 0, "DataSource isn't returning the right number of sections")
    }
    
    func testReturnsNoItemsInAnySectionByDefault() {
        XCTAssertEqual(dataSource!.numberOfItemsInSection(0), 0, "DataSource isn't returning the right number of items in section 0")
    }
    
    func testReturnsNoItemsInAnySectionByDefault2() {
        XCTAssertEqual(dataSource!.numberOfItemsInSection(1), 0, "DataSource isn't returning the right number of items in section 1")
    }
    
    func testReturnsNilForItemsAtIndexPathByDefault() {
        XCTAssertNil(dataSource?.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)), "DataSource isn't returning nil for item at indexPath")
    }
    
}
