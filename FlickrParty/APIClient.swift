//
//  APIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class APIClient: NSObject {
    
    public var parser: PhotoParser?
    
    public override convenience init() {
        self.init(parser: nil)
    }
    
    public init(parser: PhotoParser?) {
        self.parser = parser
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, completionBlock: (photos: Array<Photo>?, error: NSError?) -> Void) {
        // subclassing hook
    }
    
}
