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
   
    public var photosCache = Cache<Photo>(name: "PhotoObjectsCache")
    
    private var photos: [Photo] = []
    private let placeholderPhoto = Photo(identifier: "placeholder", title: "", details: "", ownerName: "", imageURL: nil, thumbnailURL: nil)
    
    override public func invalidateContent() {
        photos = []
        delegate?.viewDataSourceDidInvalidateContent(self)
    }
    
    override public func fetchContent(page: Int = 1) {
        loading = true
        performFetch(page) { [weak self] response, possibleError in
            if let strongSelf = self {
                strongSelf.parseAPIResponse(response, error: possibleError)
                strongSelf.loading = false
            }
        }
    }
    
    internal func performFetch(page: Int, completionBlock: (APIResponse?, NSError?) -> ()) -> Void {
        // TODO: subclassing hook
        completionBlock(nil, nil)
    }
    
    internal func parseAPIResponse(response: APIResponse?, error: NSError?) {
        if let error = error {
            delegate?.viewDataSourceDidFailFetchingContent(self, error: error)
        }
        else {
            lastMetadata = response?.metadata
            let photos = response?.responseObject as? [Photo] ?? []
            let page = lastMetadata?.page ?? 0
            if page > 1 {
                self.photos = self.photos + photos
            }
            else {
                self.photos = photos
            }
            delegate?.viewDataSourceDidFetchContent(self)
        }
    }
    
    public override func numberOfItems() -> Int {
        return photos.count
    }
    
    public override func numberOfSections() -> Int {
        return 1
    }
    
    public override func numberOfItemsInSection(section: Int) -> Int {
        return self.numberOfItems()
    }
    
    override public func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        guard indexPath.item < photos.count else { return nil }
        return photos[indexPath.item]
    }
    
    override public func itemAtIndexPath(indexPath: NSIndexPath, completion: ((AnyObject?) -> ())) {
        guard indexPath.item < photos.count else {
            completion(nil)
            return
        }
        let photo = photos[indexPath.item]
        if photo === placeholderPhoto {
            photosCache.fetch(key: indexPath.description, formatName: HanekeGlobals.Cache.OriginalFormatName, failure: { error in
                print("\(error)")
                completion(photo)
            }, success: { fetchedPhoto in
                self.photos[indexPath.item] = fetchedPhoto
                completion(fetchedPhoto)
            })
        }
        else {
            completion(photo)
        }
    }
    
    public override func cacheItemAtIndexPath(indexPath: NSIndexPath) {
        let photo = photos[indexPath.item]
        guard photo !== placeholderPhoto else { return }
        photosCache.set(value: photo, key: indexPath.description, formatName: HanekeGlobals.Cache.OriginalFormatName) { _ in
            self.photos[indexPath.item] = self.placeholderPhoto
        }
    }
    
}
