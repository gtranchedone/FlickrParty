//
//  PartyPhotosDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation

public class PartyPhotosDataSource: PhotosDataSource {

    override internal func performFetch(page: Int, completionBlock: (APIResponse?, NSError?) -> Void) -> Void {
        apiClient?.fetchPhotosWithTags(["party"], page: page, completionBlock: completionBlock)
    }
    
}
