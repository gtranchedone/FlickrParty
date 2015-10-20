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

class BaseCollectionViewControllerTests: XCTestCase {

    var viewController: BaseCollectionViewController?
    var dataSource: MockDataSource?
    
    override func setUp() {
        super.setUp()
        viewController = BaseCollectionViewController()
        dataSource = MockDataSource(apiClient: MockAPIClient())
    }
    
    override func tearDown() {
        viewController = nil
        dataSource = nil
        super.tearDown()
    }
    
    func testFetchContentWhenViewIsAboutToAppear() {
        viewController?.dataSource = dataSource
        viewController?.beginAppearanceTransition(true, animated: false)
        XCTAssertTrue(dataSource!.fetchedContent, "The view controller didn't ask the dataSource to fetch the data")
    }
    
    func testViewControllerSetsItselfAsDelegateOfTheDataSourceOnSet() {
        viewController?.dataSource = dataSource
        let delegate = viewController?.dataSource?.delegate as? BaseCollectionViewController
        XCTAssertEqual(delegate!, viewController!, "The viewController didn't set itself as the delegate of the dataSource")
    }
    
    // MARK: - UICollectionViewDataSouce
    
    func testHasNoSectionsByDefault() {
        XCTAssertEqual(0, viewController!.numberOfSectionsInCollectionView(viewController!.collectionView!))
    }
    
    func testHasNoItemsByDefault() {
        XCTAssertEqual(0, viewController!.collectionView(viewController!.collectionView!, numberOfItemsInSection: 0))
    }
    
    func testDisplaysSectionsProvidedByDataSourceWhenAvailable() {
        dataSource!.sectionsCount = 3
        viewController?.dataSource = dataSource
        XCTAssertEqual(3, viewController!.numberOfSectionsInCollectionView(viewController!.collectionView!))
    }
    
    func testDisplaysItemsProvidedByDataSourceWhenAvailable() {
        dataSource!.itemsCount = 2
        viewController?.dataSource = dataSource
        XCTAssertEqual(2, viewController!.collectionView(viewController!.collectionView!, numberOfItemsInSection: 0))
    }
    
    func testIsAlwaysAbleToDisplayCells() {
        let collectionView = MockCollectionView()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        XCTAssertNotNil(viewController?.collectionView(collectionView, cellForItemAtIndexPath: indexPath))
    }

    // MARK: View Hierarchy
    
    func testCollectionViewHasBackgroundViewAfterViewIsLoaded() {
        viewController?.view
        XCTAssertTrue(viewController!.collectionView!.backgroundView!.isKindOfClass(CollectionBackgroundView.self), "The CollectionView has no backgroundView")
    }
    
    func testInvalidatesCollectionViewLayoutWhenDeviceIsRotated() {
        let mockLayout = MockCollectionViewLayout()
        viewController = BaseCollectionViewController(collectionViewLayout: mockLayout)
        viewController?.willRotateToInterfaceOrientation(.LandscapeLeft, duration: 0.3)
        XCTAssertTrue(mockLayout.didInvalidateLayout)
    }
    
}
