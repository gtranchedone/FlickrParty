//
//  BaseCollectionViewControllerTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

// declaring the class here instead of inside the methods to make the compiler happy
class MockDataSource : ViewDataSource {
    
    var fetchedContent = false
    var sections = 0
    var items = 0
    
    override func fetchContent() {
        fetchedContent = true
    }
    
    override func numberOfSections() -> Int {
        return sections
    }
    
    override func numberOfItemsInSection(section: Int) -> Int {
        return items
    }
    
}

class BaseCollectionViewControllerTests: XCTestCase {

    var viewController: BaseCollectionViewController?
    
    override func setUp() {
        super.setUp()
        viewController = BaseCollectionViewController()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testFetchContentWhenViewIsAboutToAppear() {
        let dataSource = MockDataSource()
        viewController?.dataSource = dataSource
        viewController?.beginAppearanceTransition(true, animated: false)
        XCTAssertTrue(dataSource.fetchedContent, "The view controller didn't ask the dataSource to fetch the data")
        
    }
    
    func testViewControllerSetsItselfAsDelegateOfTheDataSourceOnSet() {
        let dataSource = MockDataSource()
        viewController?.dataSource = dataSource
        let delegate = viewController?.dataSource?.delelgate as? BaseCollectionViewController
        XCTAssertEqual(delegate!, viewController!, "The viewController didn't set itself as the delegate of the dataSource")
    }
    
    func testRespondsToCollectionViewDataSourceMethodsUsingDataSource() {
        let dataSource = MockDataSource()
        dataSource.sections = 2
        dataSource.items = 3
        
        viewController!.dataSource = dataSource
        let numberOfSections = viewController!.numberOfSectionsInCollectionView(viewController!.collectionView!)
        let numberOfItemsInSection = viewController!.collectionView(viewController!.collectionView!, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfSections, 2, "Displaying unexpected number of section")
        XCTAssertEqual(numberOfItemsInSection, 3, "Displaying unexpected number of section")
    }
    
    func testRespondsToCollectionViewDataSourceMethodsUsingDataSource2() {
        let dataSource = MockDataSource()
        dataSource.sections = 1
        dataSource.items = 2
        
        viewController!.dataSource = dataSource
        let numberOfSections = viewController!.numberOfSectionsInCollectionView(viewController!.collectionView!)
        let numberOfItemsInSection = viewController!.collectionView(viewController!.collectionView!, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfSections, 1, "Displaying unexpected number of section")
        XCTAssertEqual(numberOfItemsInSection, 2, "Displaying unexpected number of section")
    }
    
}
