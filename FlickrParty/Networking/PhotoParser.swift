//
//  PhotoParser.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class PhotoParser {
    
    public init() {}
   
    public func parseMetadata(jsonObject: AnyObject) -> APIResponseMetadata {
        // subclassing hook
        return APIResponseMetadata(page: 0, itemsPerPage: 0, numberOfPages: 0)
    }
    
    public func parsePhotos(rawObject: AnyObject) -> Array<Photo> {
        // subclassing hook
        return Array<Photo>()
    }
    
}
