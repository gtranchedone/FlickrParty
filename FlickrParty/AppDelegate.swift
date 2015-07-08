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
        let partyPhotosViewController = makePartyPhotosViewController()
        let partyPhotosNavigationController = UINavigationController(rootViewController: partyPhotosViewController)
        
        let nearbyPartyPhotosViewController = makeNearbyPartyPhotosViewController()
        let nearbyPartyPhotosNavigationController = UINavigationController(rootViewController: nearbyPartyPhotosViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [partyPhotosNavigationController, nearbyPartyPhotosNavigationController]
        window?.rootViewController = tabBarController
        
        // NOTE: for some reason you have to set the tabBarItems here otherwise they won't show up properly or change when you select them
        partyPhotosNavigationController.tabBarItem = UITabBarItem(title: partyPhotosViewController.title, image: UIImage(named: "TabIconBaloon"), selectedImage: nil)
        nearbyPartyPhotosNavigationController.tabBarItem = UITabBarItem(title: nearbyPartyPhotosViewController.title, image: UIImage(named: "TabIconLocation"), selectedImage: nil)
    }
    
    private func makePartyPhotosViewController() -> PhotosViewController {
        let viewController = PhotosViewController()
        viewController.title = "All Parties"
        viewController.dataSource = PartyPhotosDataSource(apiClient: FlickrAPIClient())
        return viewController
    }

    private func makeNearbyPartyPhotosViewController() -> PhotosViewController {
        let viewController = NearbyPartyPhotosViewController()
        viewController.title = "Parties Nearby"
        viewController.tabBarItem.title = "Parties Nearby"
        viewController.tabBarItem.image = UIImage(named: "TabIconLocation")
        return viewController
    }
    
}

