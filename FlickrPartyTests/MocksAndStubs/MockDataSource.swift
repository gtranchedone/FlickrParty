//
//  MockDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation
@testable import FlickrParty

class MockDataSourceDelegate : ViewDataSourceDelegate {
    
    var didCallDelegateForSuccess = false
    var didCallDelegateForFailure = false
    var didCallDelegateForInvalidation = false
    
    func viewDataSourceDidFetchContent(dataSource: ViewDataSource) {
        didCallDelegateForSuccess = true
    }
    
    func viewDataSourceWillFetchContent(dataSource: ViewDataSource) {
        // do nothing
    }
    
    func viewDataSourceDidInvalidateContent(dataSource: ViewDataSource) {
        didCallDelegateForInvalidation = true
    }
    
    func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError) {
        didCallDelegateForFailure = true
    }
    
}

class MockDataSource : ViewDataSource {
    
    var fetchedContent = false
    var didInvalidate = false
    var sectionsCount = 0
    var itemsCount = 0
    
    override func fetchContent(page: Int = 1) {
        fetchedContent = true
        loading = true
    }
    
    override func numberOfSections() -> Int {
        return sectionsCount
    }
    
    override func numberOfItemsInSection(section: Int) -> Int {
        return itemsCount
    }
    
    override func invalidateContent() {
        didInvalidate = true
    }
    
}

class MockNearbyPartyPhotosDataSource: NearbyPartyPhotosDataSource {
    
    var didFetchContent = false

    override func performFetch(page: Int, completionBlock: (APIResponse?, NSError?) -> Void) -> Void {
        didFetchContent = true
        completionBlock(nil, nil)
    }

}
