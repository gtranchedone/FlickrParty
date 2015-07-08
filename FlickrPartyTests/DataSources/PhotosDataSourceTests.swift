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
import CoreLocation

class MockAPIClient : APIClient {
    
    var error: NSError?
    var stubPhotos: Array<Photo>?
    var didCallFetchContent = false;
    
    var parser: PhotoParser?
    
    func fetchPhotosWithTags(tags: Array<String>, page: Int, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        didCallFetchContent = true
        let response = APIResponse(metadata: nil, responseObject: stubPhotos)
        completionBlock(response: response, error: error)
    }
    
    func fetchPhotosWithTags(tags: Array<String>, location: CLLocationCoordinate2D?, page: Int, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        // TODO: implement me
    }
    
}

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

class PhotosDataSourceTests: XCTestCase {

    var dataSource: PhotosDataSource?
    
    override func setUp() {
        super.setUp()
        dataSource = PartyPhotosDataSource(apiClient: MockAPIClient())
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
        let delegate = MockDataSourceDelegate()
        dataSource?.delegate = delegate
        dataSource?.fetchContent()
        XCTAssertTrue(delegate.didCallDelegateForSuccess, "PhotosDataSource didn't call the delegate after successfully fetching content")
    }
    
    func testCallsDelegateWithDidFailFetchingDataMessage() {
        let delegate = MockDataSourceDelegate()
        let apiClient = dataSource?.apiClient as? MockAPIClient
        apiClient?.error = NSError(domain: "TestsDomain", code: 1, userInfo: nil)
        dataSource?.delegate = delegate
        dataSource?.fetchContent()
        XCTAssertTrue(delegate.didCallDelegateForFailure, "PhotosDataSource didn't call the delegate after successfully fetching content")
    }
    
    // TODO: needs tests for caching photos

}
