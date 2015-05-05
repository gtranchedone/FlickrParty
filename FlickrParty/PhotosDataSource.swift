//
//  PhotosDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class PhotosDataSource: ViewDataSource {
   
    private var photos: Array<Photo>?
    
    override public func fetchContent() {
        if let apiClient = self.apiClient {
            apiClient.fetchPhotosWithTags(["party"]) { [unowned self] response, possibleError in
                if let error = possibleError {
                    self.delegate?.viewDataSourceDidFailFetchingContent(self, error: error)
                }
                else {
                    self.lastMetadata = response?.metadata
                    self.photos = response?.responseObject as? Array<Photo>
                    self.delegate?.viewDataSourceDidFetchContent(self)
                }
            }
        }
    }
    
    public override func numberOfItems() -> Int {
        if let photos = self.photos {
            return photos.count
        }
        else {
            return 0
        }
    }
    
    public override func numberOfSections() -> Int {
        return 1
    }
    
    public override func numberOfItemsInSection(section: Int) -> Int {
        return self.numberOfItems()
    }
    
    override public func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        if let photos = self.photos {
            return photos[indexPath.item]
        }
        else {
            return nil
        }
    }
    
}
