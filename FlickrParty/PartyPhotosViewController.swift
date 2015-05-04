//
//  PartyPhotosViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class PartyPhotosViewController: BaseCollectionViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Parties"
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .Featured, tag: 0)
    }
    
    public override func viewDataSourceDidFetchContent(dataSource: ViewDataSource) {
        stopAnimatingActivityIndicator()
        collectionView?.reloadData()
    }
    
    public override func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError) {
        if let userInfo = error.userInfo {
            var message = "Please try again later"
            if let errorMessage = userInfo[NSLocalizedDescriptionKey] as? String {
                message = errorMessage
            }
            let alertController = UIAlertController(title: "An error occurred", message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        stopAnimatingActivityIndicator()
    }
    
    private func stopAnimatingActivityIndicator() {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.activityIndicator.stopAnimating()
        }
    }
    
}
