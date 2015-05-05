//
//  FlickrPhotoParser.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class FlickrPhotoParser: PhotoParser {
    
    public override func parseMetadata(jsonObject: AnyObject) -> APIResponseMetadata {
        var page = 0
        var itemsPerPage = 0
        var numberOfPages = 0
        
        if let photosObject = jsonObject["photos"] as? Dictionary<String, AnyObject> {
            if let currentPage = photosObject["page"] as? Int {
                page = currentPage
            }
            if let perPage = photosObject["perpage"] as? Int {
                itemsPerPage = perPage
            }
            if let totalNumberOfPages = photosObject["pages"] as? Int {
                numberOfPages = totalNumberOfPages
            }
        }
        
        return APIResponseMetadata(page: page, itemsPerPage: itemsPerPage, numberOfPages: numberOfPages)
    }
    
    public override func parsePhotos(rawObject: AnyObject) -> Array<Photo> {
        var photos = Array<Photo>()
        if let jsonObject = rawObject as? Dictionary<String, AnyObject> {
            if let photosObject = jsonObject["photos"] as? Dictionary<String, AnyObject> {
                if let photosArray = photosObject["photo"] as? Array<Dictionary<String, AnyObject>> {
                    for photoJSONRepresentation in photosArray {
                        let photo = parsePhoto(photoJSONRepresentation)
                        photos.append(photo)
                    }
                }
            }
        }
        return photos
    }
    
    private func parsePhoto(jsonObject: Dictionary<String, AnyObject>) -> Photo {
        let identifier = jsonObject["id"] as? String != nil ? jsonObject["id"] as! String : ""
        let title = jsonObject["title"] as? String != nil ? jsonObject["title"] as! String : ""
        let ownerName = jsonObject["ownername"] as? String != nil ? jsonObject["ownername"] as! String : ""
        var imageURL = jsonObject["url_o"] as? String != nil ? NSURL(string: jsonObject["url_o"] as! String) : NSURL()
        if imageURL == nil {
            imageURL = jsonObject["url_l"] as? String != nil ? NSURL(string: jsonObject["url_l"] as! String) : NSURL()
        }
        let thumbnailURL = jsonObject["url_s"] as? String != nil ? NSURL(string: jsonObject["url_s"] as! String) : NSURL()
        var description = ""
        if let descriptionObject = jsonObject["description"] as? Dictionary<String, String> {
            if let descriptionString = descriptionObject["_content"] {
                description = descriptionString
            }
        }
        return Photo(identifier: identifier, title: title, description: description, ownerName: ownerName, imageURL: imageURL, thumbnailURL: thumbnailURL)
    }
    
}
