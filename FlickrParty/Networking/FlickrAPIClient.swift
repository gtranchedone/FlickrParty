//
//  FlickrAPIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import Alamofire

public class FlickrAPIClient: APIClient {
    
    public var parser: PhotoParser?
    
    static let FlickrAPIDomain = "FlickrAPIDomain"
    static let FlickrAPIKey = "31eb1c7d7d8532ac0493443606bbce13"
    
    struct FlickrAPI {
        static let TagsSearchFormat = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&tags=%@&extras=description,owner_name,url_s,url_l,url_o&api_key=%@&page=%d"
    }
    
    public convenience init() {
        self.init(parser: FlickrPhotoParser())
    }
    
    public init(parser: PhotoParser?) {
        self.parser = parser
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, page: Int = 1, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        let tagsString = join(",", tags)
        let photosURL = String(format: FlickrAPI.TagsSearchFormat, arguments: [tagsString, FlickrAPIClient.FlickrAPIKey, page])
        Alamofire.request(.GET, photosURL).responseJSON(options: .AllowFragments) { [unowned self] (_, _, jsonResponse, error) -> Void in
            if let error = error {
                completionBlock(response: nil, error: error)
            }
            else if let jsonObject = jsonResponse as? Dictionary<String, AnyObject> {
                let status = jsonObject["stat"] as? String
                if let status = status {
                    if status == "fail" {
                        let message = jsonObject["message"] as! String
                        let code = jsonObject["code"] as! Int
                        let userInfo = [NSLocalizedDescriptionKey: message, NSUnderlyingErrorKey: jsonObject.description]
                        let apiError = NSError(domain: FlickrAPIClient.FlickrAPIDomain, code: code, userInfo: userInfo)
                        completionBlock(response: nil, error: apiError)
                    }
                    else {
                        let metadata = self.parser?.parseMetadata(jsonObject)
                        let photos = self.parser?.parsePhotos(jsonObject)
                        let response = APIResponse(metadata: metadata!, responseObject: photos!)
                        completionBlock(response: response, error: nil)
                    }
                }
                else {
                    completionBlock(response: nil, error: nil)
                }
            }
        }
    }
   
}
