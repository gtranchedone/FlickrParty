//
//  NearbyPartyPhotosDataSourceTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 10/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty
import CoreLocation

class NearbyPartyPhotosDataSourceTests: XCTestCase {

    var apiClient: MockAPIClient?
    var dataSource: NearbyPartyPhotosDataSource?
    
    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        dataSource = NearbyPartyPhotosDataSource(apiClient: apiClient!)
        dataSource?.locationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    override func tearDown() {
        dataSource = nil
        apiClient = nil
        super.tearDown()
    }
    
    func testDoesNotAskAPIClientToFetchPhotosWhenAskedToFetchContentIfHasNoCoordinate() {
        dataSource = NearbyPartyPhotosDataSource(apiClient: apiClient!)
        dataSource?.fetchContent()
        XCTAssertFalse(apiClient!.didCallFetchTaggedPhotosWithLocation)
    }
    
    func testAsksAPIClientToFetchPhotosWhenAskedToFetchContent() {
        dataSource?.fetchContent()
        XCTAssertTrue(apiClient!.didCallFetchTaggedPhotosWithLocation)
    }
    
    func testDataSourceReturnsCorrectNumberOfItemsAfterFetchingPhotos() {
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
        apiClient?.error = NSError(domain: "TestsDomain", code: 1, userInfo: nil)
        dataSource?.delegate = delegate
        dataSource?.fetchContent()
        XCTAssertTrue(delegate.didCallDelegateForFailure, "PhotosDataSource didn't call the delegate after successfully fetching content")
    }
    
}
