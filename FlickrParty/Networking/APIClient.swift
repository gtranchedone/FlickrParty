//
//  APIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

public protocol APIRequest {
    
    func responseJSON(options options: NSJSONReadingOptions, completionHandler: Response<AnyObject, NSError> -> Void) -> Self
    
}

public protocol APIRequestManager {
    
    func makeRequest(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers: [String : String]?) -> APIRequest
    
}

public struct APIResponseMetadata: Equatable {
    
    public let page: Int
    public let itemsPerPage: Int
    public let numberOfPages: Int
    
    public init(page: Int, itemsPerPage: Int, numberOfPages: Int) {
        self.page = page
        self.itemsPerPage = itemsPerPage
        self.numberOfPages = numberOfPages
    }
    
}

public func ==(lhs: APIResponseMetadata, rhs: APIResponseMetadata) -> Bool {
    return (lhs.page == rhs.page && lhs.numberOfPages == rhs.numberOfPages && lhs.itemsPerPage == rhs.itemsPerPage)
}

public struct APIResponse {
    
    public let metadata: APIResponseMetadata?
    public let responseObject: AnyObject?
    
    public init(metadata: APIResponseMetadata?, responseObject: AnyObject?) {
        self.metadata = metadata
        self.responseObject = responseObject
    }
    
}

public typealias APIClientCompletionBlock = (response: APIResponse?, error: NSError?) -> ()

public protocol APIClient {
    
    var parser: PhotoParser { get set }
    
    func fetchPhotosWithTags(tags: [String], page: Int, completionBlock: APIClientCompletionBlock)
    func fetchPhotosWithTags(tags: [String], location: CLLocationCoordinate2D?, page: Int, completionBlock: APIClientCompletionBlock)
    
}
