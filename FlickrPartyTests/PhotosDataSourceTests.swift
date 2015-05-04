//
//  PhotosDataSourceTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class MockAPIClient : APIClient {
    
    var didCallFetchContent = false;
    
    override func fetchPhotosWithTags(tags: Array<String>?, completionBlock: (error: NSError?) -> Void) {
        didCallFetchContent = true
    }
    
}

class PhotosDataSourceTests: XCTestCase {

    var dataSource: PhotosDataSource?
    
    override func setUp() {
        super.setUp()
        dataSource = PhotosDataSource(apiClient: MockAPIClient())
    }
    
    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    func testAsksAPIClientToFetchPhotosWhenAskedToFetchContent() {
        dataSource?.fetchContent()
        let apiClient = dataSource!.apiClient as? MockAPIClient
        XCTAssertEqual(true, apiClient!.didCallFetchContent)
    }

}
