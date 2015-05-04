//
//  FlickrAPIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class FlickrAPIClient: APIClient {
    
    static let FlickrAPIKey = "31eb1c7d7d8532ac0493443606bbce13"
    
    struct FlickrAPI {
        let SearchFormat = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&tags=%@&extras=description,owner_name,url_t,url_o&api_key=%@"
    }
    
    public convenience init() {
        self.init(parser: FlickrPhotoParser())
    }
    
    override public init(parser: PhotoParser?) {
        super.init(parser: parser)
    }
    
    override public func fetchPhotosWithTags(tags: Array<String>?, completionBlock: (photos: Array<Photo>?, error: NSError?) -> Void) {
        // TODO: missing implementation
    }
   
}
