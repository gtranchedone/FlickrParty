//
//  MockCollectionViewLayout.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 19/10/2015.
//  Copyright © 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class MockCollectionViewLayout: UICollectionViewFlowLayout {
    
    var didInvalidateLayout = false
    
    override func invalidateLayout() {
        didInvalidateLayout = true
    }
    
}
