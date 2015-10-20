//
//  FlickrAPIClientTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import Alamofire
import CoreLocation
@testable import FlickrParty

class FlickrAPIClientTests: XCTestCase {

    var apiClient: FlickrAPIClient?
    
    override func setUp() {
        super.setUp()
        apiClient = FlickrAPIClient()
        apiClient!.networkingManager = MockAPIRequestManager()
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testAPIClientMakesExpectedRequestForFetchingPhotosWithSingleTag() {
        apiClient!.fetchPhotosWithTags(["party"]) { (response, error) -> () in }
        let mockRequest = apiClient!.networkingManager as! MockAPIRequestManager
        let format = FlickrAPIClient.FlickrAPI.TagsSearchFormat
        let arguments = ["party", FlickrAPIClient.FlickrAPI.APIKey, 1] as [CVarArgType]
        let expectedURLString = String(format: format, arguments: arguments)
        let requestedURLString = mockRequest.urlString?.URLString
        XCTAssertEqual(expectedURLString, requestedURLString)
    }
    
    func testAPIClientMakesExpectedRequestForFetchingPhotosWithMultipleTags() {
        apiClient!.fetchPhotosWithTags(["party", "dance"]) { (response, error) -> () in }
        let mockRequest = apiClient!.networkingManager as! MockAPIRequestManager
        let format = FlickrAPIClient.FlickrAPI.TagsSearchFormat
        let arguments = ["party,dance", FlickrAPIClient.FlickrAPI.APIKey, 1] as [CVarArgType]
        let expectedURLString = String(format: format, arguments: arguments)
        let requestedURLString = mockRequest.urlString?.URLString
        XCTAssertEqual(expectedURLString, requestedURLString)
    }
    
    func testAPIClientMakesExpectedRequestForFetchingPhotosWithSingleTagAndLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 1.0)
        apiClient!.fetchPhotosWithTags(["party"], location: coordinate, page: 2) { response, error in }
        let mockRequest = apiClient!.networkingManager as! MockAPIRequestManager
        let format = FlickrAPIClient.FlickrAPI.TagsAndGeoSearchFormat
        let arguments = ["party", FlickrAPIClient.FlickrAPI.APIKey, 2, 0.0, 1.0] as [CVarArgType]
        let expectedURLString = String(format: format, arguments: arguments)
        let requestedURLString = mockRequest.urlString?.URLString
        XCTAssertEqual(expectedURLString, requestedURLString)
    }
    
    func testAPIClientMakesExpectedRequestForFetchingPhotosWithMultipleTagsAndLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 1.0)
        apiClient!.fetchPhotosWithTags(["party", "dance"], location: coordinate, page: 2) { response, error in }
        let mockRequest = apiClient!.networkingManager as! MockAPIRequestManager
        let format = FlickrAPIClient.FlickrAPI.TagsAndGeoSearchFormat
        let arguments = ["party,dance", FlickrAPIClient.FlickrAPI.APIKey, 2, 0.0, 1.0] as [CVarArgType]
        let expectedURLString = String(format: format, arguments: arguments)
        let requestedURLString = mockRequest.urlString?.URLString
        XCTAssertEqual(expectedURLString, requestedURLString)
    }
    
    func testAPIClientCallsCompletionBlockWhenDoneFetchingPhotosEvenIfTheResultWasInvalid() {
        let result = Result<AnyObject, NSError>.Success([])
        fetchPhotosWithMockResponseResult(result)
    }
    
    func testAPIClientCallsCompletionBlockWithErrorWhenDoneFetchingPhotosWhenEncounteringConnectionErrors() {
        let result = Result<AnyObject, NSError>.Failure(NSError(domain: "tests", code: 400, userInfo: nil))
        fetchPhotosWithMockResponseResult(result) { response, error in
            return error != nil && response == nil
        }
    }
    
    func testAPIClientCallsCompletionBlockWithErrorWhenDoneFetchingPhotosIfTheResultCouldNotBeFetched() {
        let result = Result<AnyObject, NSError>.Success(sampleFailureJSONObject())
        fetchPhotosWithMockResponseResult(result) { response, error in
            return error != nil && response == nil
        }
    }
    
    func testAPIClientCallsCompletionBlockWithSomeResultsWhenDoneFetchingPhotosIfTheResultCouldBeCorrectlyFetched() {
        let result = Result<AnyObject, NSError>.Success(sampleSuccessJSONObject())
        fetchPhotosWithMockResponseResult(result) { response, error in
            return error == nil && response != nil
        }
    }
    
    func testAPIClientCallsCompletionBlockWithExpectedWhenDoneFetchingPhotosIfTheResultCouldBeCorrectlyFetched() {
        let sampleJSON = sampleSuccessJSONObject()
        let parser = FlickrPhotoParser()
        let expectedResponse = APIResponse(metadata: parser.parseMetadata(sampleJSON), responseObject: parser.parsePhotos(sampleJSON))
        let result = Result<AnyObject, NSError>.Success(sampleJSON)
        fetchPhotosWithMockResponseResult(result) { response, error in
            let expetedPhotos = expectedResponse.responseObject as! [Photo]
            let actualPhotos = response?.responseObject as? [Photo]
            return response!.metadata! == expectedResponse.metadata! && expetedPhotos == actualPhotos!
        }
    }

    // MARK: Helpers
    
    private func fetchPhotosWithMockResponseResult(result: Result<AnyObject, NSError>, passingConditionHandler: ((APIResponse?, NSError?) -> Bool)? = nil) {
        let expectation = expectationWithDescription("Call completion block after fetching photos")
        let coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 1.0)
        apiClient!.fetchPhotosWithTags(["party", "dance"], location: coordinate, page: 2) { response, error in
            let canFulfillExpectation = passingConditionHandler?(response, error) ?? true
            if canFulfillExpectation {
                expectation.fulfill()
            }
        }
        
        let mockRequest = apiClient!.networkingManager as! MockAPIRequestManager
        dispatch_async(dispatch_get_main_queue()) {
            let lastRequest = mockRequest.lastRequest
            let response = Response<AnyObject, NSError>(request: nil, response: nil, data: nil, result: result)
            lastRequest?.completionBlock?(response)
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    private func sampleFailureJSONObject() -> AnyObject {
        return sampleJSONObject("FlickrSearchAPIErrorResponse")
    }
    
    private func sampleSuccessJSONObject() -> AnyObject {
        return sampleJSONObject("FlickrSearchAPIResponse")
    }
    
    private func sampleJSONObject(fileName: String) -> AnyObject {
        let filePath = NSBundle(forClass: FlickrAPIClientTests.self).pathForResource(fileName, ofType: "json")
        let sampleData = NSData(contentsOfFile: filePath!)
        let jsonObject = (try! NSJSONSerialization.JSONObjectWithData(sampleData!, options: .AllowFragments)) as? [String : AnyObject]
        return jsonObject!
    }
    
}
