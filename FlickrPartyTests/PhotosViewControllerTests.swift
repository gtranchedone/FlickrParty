//
//  PartyPhotosViewControllerTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class MockPhotosViewController : PhotosViewController {
    
    var viewControllerAttemptedToPresent: UIViewController?
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewControllerAttemptedToPresent = viewControllerToPresent
    }
    
}

class PhotosViewControllerTests: XCTestCase {

    var viewController: PhotosViewController?
    
    override func setUp() {
        super.setUp()
        viewController = PhotosViewController()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    // NOTE: Basic functionality
    
    func testViewControllerIsKindOfBaseCollectionViewController() {
        // Casting to AnyObject avoid compiler warning. I prefer to keep this test as is, rather then deleting it.
        XCTAssertTrue((viewController as? AnyObject) is BaseCollectionViewController,
            "PartyPhotosViewController doesn't inherit from BaseCollectionViewController")
    }
    
    func testViewControllerReloadsDataWhenReceivingNoticeThatDataSourceFetchedData() {
        let collectionView = MockCollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        viewController?.collectionView = collectionView
        viewController?.viewDataSourceDidFetchContent(PhotosDataSource(apiClient: MockAPIClient()))
        XCTAssertTrue(collectionView.didCallReloadData, "PartyPhotosViewController didn't reload the collectionView after photos were fetched")
    }
    
    func testViewControllerPresentsAlertWhenReceivingNoticeThatDataSourceFailed() {
        let errorMessage = "This test is supposed to make this message visible to the user"
        let userInfo = [NSLocalizedDescriptionKey: errorMessage]
        let error = NSError(domain: "TestDomain", code: 1, userInfo: userInfo)
        let mockViewController = MockPhotosViewController()
        mockViewController.viewDataSourceDidFailFetchingContent(PhotosDataSource(apiClient: MockAPIClient()), error: error)
        let alertController = mockViewController.viewControllerAttemptedToPresent as? UIAlertController
        XCTAssertEqual(alertController!.message!, errorMessage, "PhotosViewController didn't present the right error message to the user")
    }
    
    func testAnimatesActivityIndicatorWhileFetchingPhotos() {
        let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView
        let activityIndicator = backgroundView?.activityIndicator
        viewController?.dataSource = MockDataSource(apiClient: MockAPIClient())
        viewController?.reloadData()
        XCTAssertTrue(activityIndicator!.isAnimating(), "PhotosViewController isn't animating activity indicator while fetching photos")
    }
    
    func testStopsAnimatingActivityIndicatorAfterFetchingPhotos() {
        let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView
        let activityIndicator = backgroundView?.activityIndicator
        viewController?.dataSource = MockDataSource(apiClient: MockAPIClient())
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.viewDataSourceDidFetchContent(viewController!.dataSource!)
        XCTAssertFalse(activityIndicator!.isAnimating(), "PhotosViewController didn't stop activity indicator after fetching photos")
    }
    
    func testStopsAnimatingActivityIndicatorAfterFailingToFetchingPhotos() {
        let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView
        let activityIndicator = backgroundView?.activityIndicator
        viewController?.dataSource = MockDataSource(apiClient: MockAPIClient())
        viewController?.beginAppearanceTransition(true, animated: false)
        let error = NSError(domain: "TestDomain", code: 0, userInfo: nil)
        viewController?.viewDataSourceDidFailFetchingContent(viewController!.dataSource!, error: error)
        XCTAssertFalse(activityIndicator!.isAnimating(), "PhotosViewController didn't stop activity indicator after fetching photos")
    }
    
    // TODO: needs tests for using new dataSource caching mechanism
    
}
