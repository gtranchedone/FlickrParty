//
//  FlickrPhotoParser.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class FlickrPhotoParser: PhotoParser {
    
    private enum PhotosAPIResultKey: String {
        case RootJSONObject = "photos"
        case PhotoObject = "photo"
        case ResponsePage = "page"
        case AvailablePages = "pages"
        case ItemsPerPage = "perpage"
    }
    
    private enum PhotoKeys: String {
        case Identifier = "id"
        case Title = "title"
        case OriginalURL = "url_o"
        case LargeImageURL = "url_l"
        case SmallImageURL = "url_s"
        case OwnerName = "ownername"
        case Description = "description"
        case DescriptionContent = "_content"
    }
    
    public init() {}
    
    public func parseMetadata(jsonObject: AnyObject) -> APIResponseMetadata {
        var page = 0
        var itemsPerPage = 0
        var numberOfPages = 0
        
        if let photosObject = jsonObject[PhotosAPIResultKey.RootJSONObject.rawValue] as? Dictionary<String, AnyObject> {
            if let currentPage = photosObject[PhotosAPIResultKey.ResponsePage.rawValue] as? Int {
                page = currentPage
            }
            if let perPage = photosObject[PhotosAPIResultKey.ItemsPerPage.rawValue] as? Int {
                itemsPerPage = perPage
            }
            if let totalNumberOfPages = photosObject[PhotosAPIResultKey.AvailablePages.rawValue] as? Int {
                numberOfPages = totalNumberOfPages
            }
        }
        
        return APIResponseMetadata(page: page, itemsPerPage: itemsPerPage, numberOfPages: numberOfPages)
    }
    
    public func parsePhotos(rawObject: AnyObject) -> Array<Photo> {
        var photos = Array<Photo>()
        if let jsonObject = rawObject as? Dictionary<String, AnyObject> {
            if let photosObject = jsonObject[PhotosAPIResultKey.RootJSONObject.rawValue] as? Dictionary<String, AnyObject> {
                if let photosArray = photosObject[PhotosAPIResultKey.PhotoObject.rawValue] as? Array<Dictionary<String, AnyObject>> {
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
        let identifier = parseStringFromJSONObject(jsonObject, key: PhotoKeys.Identifier.rawValue)
        let title = parseStringFromJSONObject(jsonObject, key: PhotoKeys.Title.rawValue)
        let ownerName = parseStringFromJSONObject(jsonObject, key: PhotoKeys.OwnerName.rawValue)
        var imageURL = NSURL(string: parseStringFromJSONObject(jsonObject, key: PhotoKeys.OriginalURL.rawValue))
        if imageURL?.absoluteString.isEmpty == true {
            imageURL = NSURL(string: parseStringFromJSONObject(jsonObject, key: PhotoKeys.LargeImageURL.rawValue))
        }
        let thumbnailURL = NSURL(string: parseStringFromJSONObject(jsonObject, key: PhotoKeys.SmallImageURL.rawValue))
        var description = ""
        if let descriptionObject = jsonObject[PhotoKeys.Description.rawValue] as? Dictionary<String, String> {
            description = parseStringFromJSONObject(descriptionObject, key: PhotoKeys.DescriptionContent.rawValue)
        }
        return Photo(identifier: identifier, title: title, details: description, ownerName: ownerName, imageURL: imageURL, thumbnailURL: thumbnailURL)
    }
    
    private func parseStringFromJSONObject(jsonObject: [String : AnyObject], key: String) -> String {
        return jsonObject[key] as? String ?? ""
    }
    
}
