//
//  NearbyPartyPhotosDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import CoreLocation

public class NearbyPartyPhotosDataSource: PhotosDataSource {
    
    public var locationCoordinate: CLLocationCoordinate2D?

    override internal func performFetch(page: Int, completionBlock: (APIResponse?, NSError?) -> Void) -> Void {
        if let locationCoordinate = locationCoordinate {
            apiClient.fetchPhotosWithTags(["party"], location: locationCoordinate, page: page, completionBlock: completionBlock)
        }
    }
    
}
