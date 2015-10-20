//
//  AppDelegateTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate?
    
    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        appDelegate?.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
    }
    
    override func tearDown() {
        appDelegate = nil
        super.tearDown()
    }

    // MARK: - Tests for Application Setup
    
    func testRootViewControllerIsTabBarController() {
        let window = appDelegate?.window
        let rootViewController = window?.rootViewController
        XCTAssert(rootViewController is UITabBarController, "The app's rootViewController isn't a TabBarController")
    }
    
    // MARK: First Tab (Photos from Parties)
    
    func testViewControllerInFirstTabHasAppropriateTitleAfterViewDidLoad() {
        let viewController = viewControllerInFirstTab()
        let actualTitle = viewController!.title
        XCTAssertEqual("All Parties", actualTitle!, "PartyPhotosViewController doesn't have an appropriate title")
    }
    
    func testRootViewControllerHasPartyPhotosControllerAsFirstTab() {
        let viewController = viewControllerInFirstTab()
        XCTAssert(viewController is PhotosViewController, "The first tab doesn't contain a PartyPhotosViewController")
    }
    
    func testPartyPhotosViewControllerHasPhotoDataSource() {
        let window = appDelegate?.window
        let rootViewController = window?.rootViewController as? UITabBarController
        let navigationController: UINavigationController? = rootViewController?.viewControllers?.first as? UINavigationController
        let viewController = navigationController?.viewControllers.first as? PhotosViewController
        XCTAssertTrue(viewController?.dataSource! is PhotosDataSource, "The PhotosViewController hasn't the right dataSource")
    }
    
    func testPartyPhotosViewControllerHasPhotoDataSourceWithRightAPIClient() {
        let window = appDelegate?.window
        let rootViewController = window?.rootViewController as? UITabBarController
        let navigationController: UINavigationController? = rootViewController?.viewControllers?.first as? UINavigationController
        let viewController = navigationController?.viewControllers.first as? PhotosViewController
        XCTAssertTrue(viewController!.dataSource!.apiClient is FlickrAPIClient, "The photosDataSource wasn't setup properly")
    }
    
    // MARK: Second Tab (Photos from Parties Near You)
    
    func testViewControllerInSecondTabHasAppropriateTitleAfterViewDidLoad() {
        let viewController = viewControllerInSecondTab()
        let actualTitle = viewController!.title
        XCTAssertEqual("Parties Nearby", actualTitle!, "PartyPhotosViewController doesn't have an appropriate title")
    }
    
    func testRootViewControllerHasNearbyPartyPhotosControllerAsSecondTab() {
        let viewController = viewControllerInSecondTab()
        XCTAssert(viewController is NearbyPartyPhotosViewController, "The second tab doesn't contain a NearbyPartyPhotosViewController")
    }
    
    // MARK: Private
    
    func viewControllerInFirstTab() -> UIViewController? {
        return viewControllerInTabAtIndex(0)
    }
    
    func viewControllerInSecondTab() -> UIViewController? {
        return viewControllerInTabAtIndex(1)
    }
    
    func viewControllerInTabAtIndex(index: Int) -> UIViewController? {
        let window = appDelegate?.window
        let rootViewController = window?.rootViewController as? UITabBarController
        let navigationController: UINavigationController? = rootViewController?.viewControllers?[index] as? UINavigationController
        let viewController = navigationController?.viewControllers.first
        return viewController
    }

}
