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
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makePartyPhotosViewController(), makeNearbyPartyPhotosViewController()]
        window?.rootViewController = tabBarController
    }
    
    private func makePartyPhotosViewController() -> UIViewController {
        let viewController = PhotosViewController()
        viewController.title = "All Parties"
        viewController.dataSource = PartyPhotosDataSource(apiClient: FlickrAPIClient())
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named: "TabIconBaloon"), selectedImage: nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    private func makeNearbyPartyPhotosViewController() -> UIViewController {
        let viewController = NearbyPartyPhotosViewController()
        viewController.title = "Parties Nearby"
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named: "TabIconLocation"), selectedImage: nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
}

