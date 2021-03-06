//
//  PhotoParser.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public protocol PhotoParser {
   
    func parseMetadata(jsonObject: AnyObject) -> APIResponseMetadata
    func parsePhotos(rawObject: AnyObject) -> Array<Photo>
    
}
