//
//  FlickrPhotoParser.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class FlickrPhotoParser: PhotoParser {
    
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
        let imageURL = jsonObject["url_o"] as? String != nil ? NSURL(string: jsonObject["url_o"] as! String)! : NSURL()
        let thumbnailURL = jsonObject["url_t"] as? String != nil ? NSURL(string: jsonObject["url_t"] as! String)! : NSURL()
        var description = ""
        if let descriptionObject = jsonObject["description"] as? Dictionary<String, String> {
            if let descriptionString = descriptionObject["_content"] {
                description = descriptionString
            }
        }
        return Photo(identifier: identifier, title: title, description: description, ownerName: ownerName, imageURL: imageURL, thumbnailURL: thumbnailURL)
    }
    
}
