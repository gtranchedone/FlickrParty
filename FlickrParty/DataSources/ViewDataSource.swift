//
//  ViewDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public protocol ViewDataSourceDelegate {
    
    func viewDataSourceDidFetchContent(dataSource: ViewDataSource)
    func viewDataSourceWillFetchContent(dataSource: ViewDataSource)
    func viewDataSourceDidInvalidateContent(dataSource: ViewDataSource)
    func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError)
    
}

public class ViewDataSource: NSObject {
    
    public var delegate: ViewDataSourceDelegate?
    public var lastMetadata: APIResponseMetadata?
    public var apiClient: APIClient
    public var loading = false {
        didSet {
            if loading {
                self.delegate?.viewDataSourceWillFetchContent(self)
            }
        }
    }
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
        super.init()
    }
    
    public func invalidateContent() {
        // subclassing hook
    }
    
    public func fetchContent(page: Int = 1) {
        // subclassing hook
    }
    
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
    
    public func itemAtIndexPath(indexPath: NSIndexPath, completion: ((AnyObject?) -> ())) {
        // subclassing hook
    }
    
    public func cacheItemAtIndexPath(indexPath: NSIndexPath) {
        // subclassing hook
    }
   
}
