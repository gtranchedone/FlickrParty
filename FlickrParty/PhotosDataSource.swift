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
    
    override public func invalidateContent() {
        photos = nil
        self.delegate?.viewDataSourceDidInvalidateContent(self)
    }
    
    override public func fetchContent(page: Int = 1) {
        if let apiClient = self.apiClient {
            apiClient.fetchPhotosWithTags(["party"], page: page) { [unowned self] response, possibleError in
                if let error = possibleError {
                    self.delegate?.viewDataSourceDidFailFetchingContent(self, error: error)
                }
                else {
                    self.lastMetadata = response?.metadata
                    let photos = response?.responseObject as? Array<Photo>
                    if let page = self.lastMetadata?.page {
                        if page > 1 {
                            self.photos = self.photos! + photos!
                        }
                        else {
                            self.photos = photos
                        }
                    }
                    else {
                        self.photos = photos
                    }
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
