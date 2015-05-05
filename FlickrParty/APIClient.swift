//
//  APIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

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

public class APIClient: NSObject {
    
    public var parser: PhotoParser?
    
    public override convenience init() {
        self.init(parser: nil)
    }
    
    public init(parser: PhotoParser?) {
        self.parser = parser
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        // subclassing hook
    }
    
}
