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

class MockAPIClient : APIClient {
    
    var error: NSError?
    var stubPhotos: Array<Photo>?
    var didCallFetchTaggedPhotos = false;
    var didCallFetchTaggedPhotosWithLocation = false;
    
    var parser: PhotoParser?
    
    func fetchPhotosWithTags(tags: Array<String>, page: Int, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        didCallFetchTaggedPhotos = true
        let response = APIResponse(metadata: nil, responseObject: stubPhotos)
        completionBlock(response: response, error: error)
    }
    
    func fetchPhotosWithTags(tags: Array<String>, location: CLLocationCoordinate2D?, page: Int, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        didCallFetchTaggedPhotosWithLocation = true
        let response = APIResponse(metadata: nil, responseObject: stubPhotos)
        completionBlock(response: response, error: error)
    }
    
}
