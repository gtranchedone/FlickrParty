//
//  MockDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import FlickrParty

class MockDataSource : ViewDataSource {
    
    var fetchedContent = false
    var didInvalidate = false
    var sections = 0
    var items = 0
    
    override func fetchContent(page: Int = 1) {
        fetchedContent = true
        loading = true
    }
    
    override func numberOfSections() -> Int {
        return sections
    }
    
    override func numberOfItemsInSection(section: Int) -> Int {
        return items
    }
    
    override func invalidateContent() {
        didInvalidate = true
    }
    
}