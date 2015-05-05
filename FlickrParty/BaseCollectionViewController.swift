//
//  BaseCollectionViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

let DefaultCellReuseIdentifier = "DefaultCellReuseIdentifier"

public class BaseCollectionViewController: UICollectionViewController, ViewDataSourceDelegate {

    public var dataSource: ViewDataSource? {
        didSet {
            dataSource?.delegate = self
        }
    }
    
    public convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: flowLayout)
    }
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: DefaultCellReuseIdentifier)
        self.collectionView!.backgroundView = CollectionBackgroundView(frame: self.collectionView!.bounds)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("\n\n!!!\nDid Receive Memory Warning\n!!!\n\n")
    }
    
    public override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // make sure that after every rotation of the device, the layout is valid
        self.collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Helpers
    
    public func reloadData() {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.activityIndicator.startAnimating()
        }
        if let dataSource = self.dataSource {
            dataSource.fetchContent()
        }
    }

    // MARK: UICollectionViewDataSource

    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.numberOfSections()
        }
        else {
            return 0
        }
    }


    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.numberOfItemsInSection(section)
        }
        else {
            return 0
        }
    }

    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DefaultCellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    // MARK: ViewDataSourceDelegate
    
    public func viewDataSourceDidFetchContent(dataSource: ViewDataSource) {
        stopAnimatingActivityIndicator()
        collectionView?.reloadData()
    }
    
    public func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError) {
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
