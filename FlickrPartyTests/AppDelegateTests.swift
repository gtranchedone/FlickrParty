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

    func testRootViewControllerIsTabBarController() {
        let window = appDelegate?.window
        let rootViewController = window?.rootViewController
        XCTAssert(rootViewController is UITabBarController, "The app's rootViewController isn't a TabBarController")
    }
    
    func testRootViewControllerHasPartyPhotosControllerAsFirstTab() {
        let window = appDelegate?.window
        let rootViewController = window?.rootViewController as? UITabBarController
        let navigationController: UINavigationController? = rootViewController?.viewControllers?.first as? UINavigationController
        let viewController = navigationController?.viewControllers.first as? UIViewController
        XCTAssert(viewController is PartyPhotosViewController, "The first tab doesn't contain a PartyPhotosViewController")
    }

}
