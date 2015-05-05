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
    
    var error: NSError?
    var stubPhotos: Array<Photo>?
    var didCallFetchContent = false;
    
    override func fetchPhotosWithTags(tags: Array<String>?, completionBlock: (photos: Array<Photo>?, error: NSError?) -> Void) {
        didCallFetchContent = true
        completionBlock(photos:stubPhotos, error: error)
    }
    
}

class MockDelegate : ViewDataSourceDelegate {
    
    var didCallDelegateForSuccess = false
    var didCallDelegateForFailure = false
    
    func viewDataSourceDidFetchContent(dataSource: ViewDataSource) {
        didCallDelegateForSuccess = true
    }
    
    func viewDataSourceDidFailFetchingContent(dataSource: ViewDataSource, error: NSError) {
        didCallDelegateForFailure = true
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
    
    func testDataSourceReturnsCorrectNumberOfItemsAfterFetchingPhotos() {
        let apiClient = dataSource!.apiClient as? MockAPIClient
        apiClient?.stubPhotos = [Photo(identifier: "", title: "", description: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)]
        dataSource?.fetchContent()
        XCTAssertEqual(1, dataSource!.numberOfItems(), "PhotosDataSource not returning correct number of items")
    }
    
    func testCallsDelegateWithDidFetchDataMessage() {
        let delegate = MockDelegate()
        dataSource?.delegate = delegate
        dataSource?.fetchContent()
        XCTAssertTrue(delegate.didCallDelegateForSuccess, "PhotosDataSource didn't call the delegate after successfully fetching content")
    }
    
    func testCallsDelegateWithDidFailFetchingDataMessage() {
        let delegate = MockDelegate()
        let apiClient = dataSource?.apiClient as? MockAPIClient
        apiClient?.error = NSError(domain: "TestsDomain", code: 1, userInfo: nil)
        dataSource?.delegate = delegate
        dataSource?.fetchContent()
        XCTAssertTrue(delegate.didCallDelegateForFailure, "PhotosDataSource didn't call the delegate after successfully fetching content")
    }

}
