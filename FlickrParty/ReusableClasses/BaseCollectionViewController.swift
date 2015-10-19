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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: DefaultCellReuseIdentifier)
        self.collectionView!.backgroundView = CollectionBackgroundView(frame: self.collectionView!.bounds)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (dataSource?.numberOfItems() <= 0) {
            reloadData()
        }
    }
    
    public override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // make sure that after every rotation of the device, the layout is valid
        self.collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Public APIs
    
    public func reloadData() {
        if let dataSource = self.dataSource {
            dataSource.fetchContent()
        }
    }

    // MARK: UICollectionViewDataSource

    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }


    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItemsInSection(section) ?? 0
    }

    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DefaultCellReuseIdentifier, forIndexPath: indexPath) 
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    // MARK: ViewDataSourceDelegate
    
    public func viewDataSourceDidFetchContent(dataSource: ViewDataSource) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        updateBackgroundLabelWithMessage(nil)
        stopAnimatingActivityIndicator()
        collectionView?.reloadData()
    }
    
    public func viewDataSourceDidInvalidateContent(dataSource: ViewDataSource) {
        collectionView?.reloadData()
    }
    
    public func viewDataSourceWillFetchContent(dataSource: ViewDataSource) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        updateBackgroundLabelWithMessage(nil)
        if dataSource.numberOfItems() <= 0 {
            startAnimatingActivityIndicator()
        }
    }
    
    public func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError) {
        var message = "We were unable to load any photo"
        if let errorMessage = error.userInfo[NSLocalizedDescriptionKey] as? String {
            message = errorMessage
        }
        presentAlertWithMessage(message)
        stopAnimatingActivityIndicator()
        updateBackgroundLabelWithMessage(message)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    private func presentAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "An error occurred", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func updateBackgroundLabelWithMessage(message: String?) {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.textLabel.text = message
        }
    }
    
    private func stopAnimatingActivityIndicator() {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.activityIndicator.stopAnimating()
        }
    }
    
    private func startAnimatingActivityIndicator() {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.activityIndicator.startAnimating()
        }
    }

}
