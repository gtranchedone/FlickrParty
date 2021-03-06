//
//  PartyPhotosDataSourceTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation
@testable import FlickrParty

class PartyPhotosDataSourceTests: XCTestCase {

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
        XCTAssertEqual(true, apiClient!.didCallFetchTaggedPhotos)
    }
    
    func testDataSourceReturnsCorrectNumberOfItemsAfterFetchingPhotos() {
        let apiClient = dataSource!.apiClient as? MockAPIClient
        apiClient?.stubPhotos = [Photo(identifier: "", title: "", details: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)]
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
