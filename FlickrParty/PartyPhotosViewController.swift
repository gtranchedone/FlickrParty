//
//  PartyPhotosViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import Haneke

let PhotoCellReuseIdentifier = "PhotoCellReuseIdentifier"

public class PartyPhotosViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let imageCache = Cache<UIImage>(name: "PartyPhotosCache")
    
    public convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        self.init(collectionViewLayout: flowLayout)
    }
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        imageCache.removeAll() // to avoid crash with some issue in Haneke
        super.viewDidLoad()
        self.title = "Parties"
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .Featured, tag: 0)
        self.collectionView!.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCellReuseIdentifier)
    }
    
    // MARK: - UICollectionViewDelegate -
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCellReuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photo = dataSource!.itemAtIndexPath(indexPath) as! Photo
        if let thumbnailURL = photo.thumbnailURL {
            let imageFetcher = NetworkFetcher<UIImage>(URL: thumbnailURL)
            imageCache.fetch(fetcher: imageFetcher).onSuccess { image in
                let newIndexPath = collectionView.indexPathForCell(cell)
                if let theIndexPath = newIndexPath {
                    if theIndexPath == indexPath {
                        cell.imageView.image = image
                    }
                }
                else {
                    cell.imageView.image = image
                }
            }
        }
        return cell
    }
    
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let viewController = PhotoDetailsViewController()
        viewController.photo = dataSource!.itemAtIndexPath(indexPath) as? Photo
        viewController.hidesBottomBarWhenPushed = true
        self.showViewController(viewController, sender: indexPath)
    }
    
    // MARK: - UICollectionViewFlowLayoutDelegate -
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let sideLenght = ((collectionView.bounds.size.width - sectionInsets - (flowLayout.minimumInteritemSpacing * 2)) / 3)
        return CGSizeMake(sideLenght, sideLenght)
    }
    
}
