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
        let stubDataSource = MockDataSource()
        stubDataSource.sectionsCount = 3
        viewController?.dataSource = stubDataSource
        XCTAssertEqual(3, viewController!.numberOfSectionsInCollectionView(viewController!.collectionView!))
    }
    
    func testDisplaysItemsProvidedByDataSourceWhenAvailable() {
        let stubDataSource = MockDataSource()
        stubDataSource.itemsCount = 2
        viewController?.dataSource = stubDataSource
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
