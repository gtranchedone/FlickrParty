//
//  PhotosDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import Haneke

public class PhotosDataSource: ViewDataSource {
   
    private var photos: Array<Photo>?
    public var photosCache = Cache<Photo>(name: "PhotoObjectsCache")
    private let placeholderPhoto = Photo(identifier: "", title: "", details: "", ownerName: "", imageURL: nil, thumbnailURL: nil)
    
    override public func invalidateContent() {
        photos = nil
        self.delegate?.viewDataSourceDidInvalidateContent(self)
    }
    
    override public func fetchContent(page: Int = 1) {
        guard apiClient != nil else { return }
        loading = true
        performFetch(page) { [unowned self] response, possibleError in
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
            self.loading = false
        }
    }
    
    internal func performFetch(page: Int, completionBlock: (APIResponse?, NSError?) -> Void) -> Void {
        // TODO: subclassing hook
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
    
    override public func itemAtIndexPath(indexPath: NSIndexPath, completion: ((AnyObject?) -> ())) {
        if let photos = self.photos {
            let photo = photos[indexPath.item]
            if photo === placeholderPhoto {
                photosCache.fetch(key: indexPath.description, formatName: HanekeGlobals.Cache.OriginalFormatName).onFailure({ error in
                    print("\(error)")
                    completion(photo)
                }).onSuccess { fetchedPhoto in
                    self.photos?[indexPath.item] = fetchedPhoto
                    completion(fetchedPhoto)
                }
            }
            else {
                completion(photo)
            }
        }
    }
    
    public override func cacheItemAtIndexPath(indexPath: NSIndexPath) {
        if let thePhotos = photos {
            let photo = thePhotos[indexPath.item]
            if photo === placeholderPhoto {
                return
            }
            
            photosCache.set(value: photo, key: indexPath.description, formatName: HanekeGlobals.Cache.OriginalFormatName, success: { fetchedPhoto in
                self.photos?[indexPath.item] = self.placeholderPhoto
            })
        }
    }
    
}
