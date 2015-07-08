//
//  AppDelegate.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?


    /// MARK: - UIApplicationDelegate -
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpWindow()
        setUpRootViewController()
        return true
    }
    
    /// MARK: Helpers
    
    private func setUpWindow() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
    }
    
    private func setUpRootViewController() {
        let partyPhotosViewController = PhotosViewController()
        partyPhotosViewController.dataSource = PartyPhotosDataSource(apiClient: FlickrAPIClient())
        let partyPhotosNavigationController = UINavigationController(rootViewController: partyPhotosViewController)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [partyPhotosNavigationController]
        window?.rootViewController = tabBarController
    }


}

