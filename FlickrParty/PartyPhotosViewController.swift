//
//  PartyPhotosViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class PartyPhotosViewController: UICollectionViewController {
 
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
