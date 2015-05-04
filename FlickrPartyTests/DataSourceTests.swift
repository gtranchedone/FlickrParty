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

    var dataSource: DataSource?
    
    override func setUp() {
        super.setUp()
        self.dataSource = DataSource()
    }
    
    override func tearDown() {
        self.dataSource = nil
        super.tearDown()
    }

    func testReturnsNoItemsByDefault() {
        XCTAssertEqual(self.dataSource!.numberOfItems(), 0, "DataSource isn't returning the right number of items")
    }

    func testReturnsNoSectionsByDefault() {
        XCTAssertEqual(self.dataSource!.numberOfSections(), 0, "DataSource isn't returning the right number of sections")
    }
    
    func testReturnsNoItemsInAnySectionByDefault() {
        XCTAssertEqual(self.dataSource!.numberOfItemsInSection(0), 0, "DataSource isn't returning the right number of items in section 0")
    }
    
    func testReturnsNoItemsInAnySectionByDefault2() {
        XCTAssertEqual(self.dataSource!.numberOfItemsInSection(1), 0, "DataSource isn't returning the right number of items in section 1")
    }
    
    func testReturnsNilForItemsAtIndexPathByDefault() {
        XCTAssertNil(self.dataSource?.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)), "DataSource isn't returning nil for item at indexPath")
    }
    
}
