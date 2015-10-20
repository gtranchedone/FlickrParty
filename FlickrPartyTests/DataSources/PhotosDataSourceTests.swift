//
//  PhotosDataSourceTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 19/10/2015.
//  Copyright © 2015 Gianluca Tranchedone. All rights reserved.
//

import XCTest
import Haneke
@testable import FlickrParty

class PhotosDataSourceTests: XCTestCase {
    
    var apiClient: MockAPIClient?
    var dataSource: PhotosDataSource?
    var dataSourceDelegate: MockDataSourceDelegate?

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        dataSource = PhotosDataSource(apiClient: apiClient!)
        dataSourceDelegate = MockDataSourceDelegate()
        dataSource?.delegate = dataSourceDelegate
    }
    
    override func tearDown() {
        apiClient = nil
        dataSource = nil
        dataSourceDelegate = nil
        super.tearDown()
    }

    func testThatItAlwaysHasOneContentSection() {
        XCTAssertEqual(1, dataSource!.numberOfSections())
    }
    
    func testHasNoPhotosForClientsByDefault() {
        XCTAssertEqual(0, dataSource!.numberOfItemsInSection(0))
    }
    
    func testReturnsNoPhotoForAnyIndexPathByDefault() {
        XCTAssertNil(dataSource!.itemAtIndexPath(NSIndexPath(forItem: 2, inSection: 5)))
    }
    
    func testUpdatesStateToLoadingWhenFetchingContent() {
        dataSource!.fetchContent()
        XCTAssertTrue(dataSourceDelegate!.didCallDelegateForStartingFetch)
    }
    
    func testUpdatesStateToIdleWhenFinishedFetchingContent() {
        dataSource!.fetchContent()
        XCTAssertFalse(dataSource!.loading)
    }
    
    func testParsingAPIResponseWithErrorInformsDelegateOfFailure() {
        let error = NSError(domain: "test domain", code: 400, userInfo: nil)
        dataSource!.parseAPIResponse(nil, error: error)
        XCTAssertTrue(dataSourceDelegate!.didCallDelegateForFailure)
    }
    
    func testParsingAPIResponseWithoutErrorInformsDelegateOfSuccess() {
        dataSource!.parseAPIResponse(nil, error: nil)
        XCTAssertTrue(dataSourceDelegate!.didCallDelegateForSuccess)
    }
    
    func testParsingAPIResponseWithPhotosMakesThemAvailableForUseByClients() {
        loadSamplePhotos()
        XCTAssertEqual(100, dataSource!.numberOfItemsInSection(0))
    }
    
    func testParsingAPIResponseWithPhotosForSubsequentPagesAddTheNewPhotosToThoseAlreadyFetched() {
        let parser = FlickrPhotoParser()
        let photos = parser.parsePhotos(sampleJSONObject())
        let response = APIResponse(metadata: nil, responseObject: photos)
        dataSource!.parseAPIResponse(response, error: nil)
        let stubMetadata = APIResponseMetadata(page: 2, itemsPerPage: 100, numberOfPages: 200)
        let secondResponse = APIResponse(metadata: stubMetadata, responseObject: photos)
        dataSource!.parseAPIResponse(secondResponse, error: nil)
        XCTAssertEqual(200, dataSource!.numberOfItemsInSection(0))
    }
    
    func testReturnsPhotosWhenAskedForItemsAtIndexPathThatHavePhotosAfterFetch() {
        loadSamplePhotos()
        XCTAssertNotNil(dataSource!.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)))
    }
    
    func testReturnsNoPhotoWhenAskedForItemsAtIndexPathThatAreOutOfBoundsAfterFetch() {
        loadSamplePhotos()
        XCTAssertNil(dataSource!.itemAtIndexPath(NSIndexPath(forItem: 100, inSection: 0)))
    }
    
    func testReturnsImmediatelyNilWhenAskingForItemAsynchronouslyAndPassingAnOutOfBoundsIndexPath() {
        dataSource!.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) { photo in
            XCTAssertNil(photo)
        }
    }
    
    func testReturnsImmediatelyPhotoWhenAskingForItemAsynchronouslyAndPassingValidIndexPath() {
        let parser = FlickrPhotoParser()
        let photos = parser.parsePhotos(sampleJSONObject())
        let response = APIResponse(metadata: nil, responseObject: photos)
        dataSource!.parseAPIResponse(response, error: nil)
        dataSource!.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) { photo in
            XCTAssertNotNil(photo)
        }
    }
    
    func testCachingPhotosDoesNotAlterNumberOfItemsButRemovesPhotoForEfficiency() {
        loadSamplePhotos()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let photo = dataSource!.itemAtIndexPath(indexPath) as! Photo
        dataSource!.photosCache = Cache<Photo>(name: "Test Cache")
        dataSource!.cacheItemAtIndexPath(indexPath)
        let placeholderPhoto = dataSource!.itemAtIndexPath(indexPath) as! Photo
        XCTAssertNotNil(placeholderPhoto)
        XCTAssertNotEqual(photo, placeholderPhoto)
    }
    
    func testDoesNothingWhenTryingToCacheAlreadyCachedItem() {
        loadSamplePhotos()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let photo = dataSource!.itemAtIndexPath(indexPath) as! Photo
        dataSource!.photosCache = Cache<Photo>(name: "Test Cache")
        dataSource!.cacheItemAtIndexPath(indexPath)
        dataSource!.cacheItemAtIndexPath(indexPath) // yest, twice
        let placeholderPhoto = dataSource!.itemAtIndexPath(indexPath) as! Photo
        XCTAssertNotNil(placeholderPhoto)
        XCTAssertNotEqual(photo, placeholderPhoto)
    }
    
    func testFetchingAsynchronouslyCachedItemReturnsTheOriginalItemInsteadOfPlaceholder() {
        loadSamplePhotos()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let photo = dataSource!.itemAtIndexPath(indexPath) as! Photo
        dataSource!.photosCache = Cache<Photo>(name: "Test Cache")
        dataSource!.cacheItemAtIndexPath(indexPath)
        
        let expectation = expectationWithDescription("Fetch cached photo")
        dataSource!.itemAtIndexPath(indexPath) { fetchedPhoto in
            XCTAssertEqual(photo, fetchedPhoto as? Photo)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testFetchingAsyncrhronouslyCachedItemReturnsPlaceholderIfFetchFromCacheFails() {
        loadSamplePhotos()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let mockCache = MockCache<Photo>(name: "Test Cache")
        mockCache.needsToFail = true
        
        dataSource!.photosCache = mockCache
        dataSource!.cacheItemAtIndexPath(indexPath)
        let placeholderPhoto = dataSource!.itemAtIndexPath(indexPath) as! Photo
        
        let expectation = expectationWithDescription("Fetch cached photo")
        dataSource!.itemAtIndexPath(indexPath) { fetchedPhoto in
            XCTAssertEqual(placeholderPhoto, fetchedPhoto as? Photo)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    // MARK: Helpers
    
    private func loadSamplePhotos() {
        let parser = FlickrPhotoParser()
        let photos = parser.parsePhotos(sampleJSONObject())
        let response = APIResponse(metadata: nil, responseObject: photos)
        dataSource!.parseAPIResponse(response, error: nil)
    }
    
    private func sampleJSONObject() -> AnyObject {
        let filePath = NSBundle(forClass: FlickrAPIClientTests.self).pathForResource("FlickrSearchAPIResponse", ofType: "json")
        let sampleData = NSData(contentsOfFile: filePath!)
        let jsonObject = (try! NSJSONSerialization.JSONObjectWithData(sampleData!, options: .AllowFragments)) as? [String : AnyObject]
        return jsonObject!
    }

}
