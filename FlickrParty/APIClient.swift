//
//  APIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class APIClient: NSObject {
   
    public func fetchPhotosWithTags(tags: Array<String>?, completionBlock: (error: NSError?) -> Void) {
        // subclassing hook
    }
    
}
