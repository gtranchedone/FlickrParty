//
//  FlickrPhotoParser.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class FlickrPhotoParser: PhotoParser {
    
    private struct PhotosAPIResultKey {
        static let RootJSONObject = "photos"
        static let PhotoObject = "photo"
        static let ResponsePage = "page"
        static let AvailablePages = "pages"
        static let ItemsPerPage = "perpage"
    }
    
    private struct PhotoKeys {
        static let Identifier = "id"
        static let Title = "title"
        static let OriginalURL = "url_o"
        static let LargeImageURL = "url_l"
        static let SmallImageURL = "url_s"
        static let OwnerName = "ownername"
        static let Description = "description"
        static let DescriptionContent = "_content"
    }
    
    public override func parseMetadata(jsonObject: AnyObject) -> APIResponseMetadata {
        var page = 0
        var itemsPerPage = 0
        var numberOfPages = 0
        
        if let photosObject = jsonObject[PhotosAPIResultKey.RootJSONObject] as? Dictionary<String, AnyObject> {
            if let currentPage = photosObject[PhotosAPIResultKey.ResponsePage] as? Int {
                page = currentPage
            }
            if let perPage = photosObject[PhotosAPIResultKey.ItemsPerPage] as? Int {
                itemsPerPage = perPage
            }
            if let totalNumberOfPages = photosObject[PhotosAPIResultKey.AvailablePages] as? Int {
                numberOfPages = totalNumberOfPages
            }
        }
        
        return APIResponseMetadata(page: page, itemsPerPage: itemsPerPage, numberOfPages: numberOfPages)
    }
    
    public override func parsePhotos(rawObject: AnyObject) -> Array<Photo> {
        var photos = Array<Photo>()
        if let jsonObject = rawObject as? Dictionary<String, AnyObject> {
            if let photosObject = jsonObject[PhotosAPIResultKey.RootJSONObject] as? Dictionary<String, AnyObject> {
                if let photosArray = photosObject[PhotosAPIResultKey.PhotoObject] as? Array<Dictionary<String, AnyObject>> {
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
        let identifier = parseStringFromJSONObject(jsonObject, key: PhotoKeys.Identifier)
        let title = parseStringFromJSONObject(jsonObject, key: PhotoKeys.Title)
        let ownerName = parseStringFromJSONObject(jsonObject, key: PhotoKeys.OwnerName)
        var imageURL = NSURL(string: parseStringFromJSONObject(jsonObject, key: PhotoKeys.OriginalURL))
        if imageURL?.absoluteString?.isEmpty == true {
            imageURL = NSURL(string: parseStringFromJSONObject(jsonObject, key: PhotoKeys.LargeImageURL))
        }
        let thumbnailURL = NSURL(string: parseStringFromJSONObject(jsonObject, key: PhotoKeys.SmallImageURL))
        var description = ""
        if let descriptionObject = jsonObject[PhotoKeys.Description] as? Dictionary<String, String> {
            description = parseStringFromJSONObject(descriptionObject, key: PhotoKeys.DescriptionContent)
        }
        return Photo(identifier: identifier, title: title, description: description, ownerName: ownerName, imageURL: imageURL, thumbnailURL: thumbnailURL)
    }
    
    private func parseStringFromJSONObject(jsonObject: Dictionary<String, AnyObject>, key: String) -> String {
        if let parsedString = jsonObject[key] as? String {
            return parsedString
        }
        else {
            return ""
        }
    }
    
}
