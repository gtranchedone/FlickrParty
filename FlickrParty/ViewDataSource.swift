//
//  DataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class ViewDataSource: NSObject {
    
    public func numberOfItems() -> Int {
        return 0
    }
    
    public func numberOfSections() -> Int {
        return 0
    }
    
    public func numberOfItemsInSection(section: Int) -> Int {
        return 0
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        return nil
    }
   
}
