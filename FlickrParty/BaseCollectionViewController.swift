//
//  BaseCollectionViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

public class BaseCollectionViewController: UICollectionViewController, ViewDataSourceDelegate {

    public var dataSource: ViewDataSource? {
        didSet {
            dataSource?.delegate = self
        }
    }
    
    public init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let dataSource = self.dataSource {
            dataSource.fetchContent()
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    // MARK: ViewDataSourceDelegate
    
    public func viewDataSourceDidFetchContent(dataSource: ViewDataSource) {
        // TODO: missing implementation
    }
    
    public func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError) {
        // TODO: missing implementation
    }

}
