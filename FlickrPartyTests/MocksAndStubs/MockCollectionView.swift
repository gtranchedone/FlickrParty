//
//  MockCollectionView.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 19/10/2015.
//  Copyright © 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class MockCollectionView : UICollectionView {
    
    var didCallReloadData = false
    
    convenience init() {
        self.init(frame: CGRectZero, collectionViewLayout: MockCollectionViewLayout())
    }
    
    override func reloadData() {
        didCallReloadData = true
    }
    
    override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
