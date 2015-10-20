//
//  MockAPIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 10/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import FlickrParty
import CoreLocation
import Alamofire

class MockAPIRequest: APIRequest {
    
    var completionBlock: (Response<AnyObject, NSError> -> Void)?
    
    func responseJSON(options options: NSJSONReadingOptions = .AllowFragments, completionHandler: Response<AnyObject, NSError> -> Void) -> Self {
        completionBlock = completionHandler
        return self
    }
    
}

class MockAPIRequestManager: APIRequestManager {
    
    var requestMethod: Alamofire.Method?
    var urlString: URLStringConvertible?
    var parameters: [String : AnyObject]?
    var encoding: ParameterEncoding?
    var headers: [String : String]?
    var lastRequest: MockAPIRequest?
    
    func makeRequest(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers: [String : String]?) -> APIRequest {
        requestMethod = method
        self.urlString = URLString
        self.parameters = parameters
        self.encoding = encoding
        lastRequest = MockAPIRequest()
        return lastRequest!
    }
    
}

class MockAPIClient : APIClient {
    
    var error: NSError?
    var stubPhotos: Array<Photo>?
    var canCallCompletionBlock = true
    var didCallFetchTaggedPhotos = false;
    var didCallFetchTaggedPhotosWithLocation = false;
    
    var parser: PhotoParser = FlickrPhotoParser()
    
    func fetchPhotosWithTags(tags: [String], page: Int, completionBlock: APIClientCompletionBlock) {
        didCallFetchTaggedPhotos = true
        if canCallCompletionBlock {
            let response = APIResponse(metadata: nil, responseObject: stubPhotos)
            completionBlock(response: response, error: error)
        }
    }
    
    func fetchPhotosWithTags(tags: [String], location: CLLocationCoordinate2D?, page: Int, completionBlock: APIClientCompletionBlock) {
        didCallFetchTaggedPhotosWithLocation = true
        if canCallCompletionBlock {
            let response = APIResponse(metadata: nil, responseObject: stubPhotos)
            completionBlock(response: response, error: error)
        }
    }
    
}
