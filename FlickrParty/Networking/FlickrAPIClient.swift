//
//  FlickrAPIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Alamofire
import CoreLocation

public class FlickrAPIClient: APIClient {
    
    public var parser: PhotoParser?
    
    static let FlickrAPIDomain = "FlickrAPIDomain"
    static let FlickrAPIKey = "31eb1c7d7d8532ac0493443606bbce13"
    
    struct FlickrAPI {
        static let TagsSearchFormat = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&tags=%@&extras=description,owner_name,url_s,url_l,url_o&api_key=%@&page=%d"
        static let TagsAndGeoSearchFormat = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&tags=%@&extras=description,owner_name,url_s,url_l,url_o,geo&has_geo=1&api_key=%@&page=%d&lat=%f&long=%f"
    }
    
    public convenience init() {
        self.init(parser: FlickrPhotoParser())
    }
    
    public init(parser: PhotoParser?) {
        self.parser = parser
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, page: Int = 1, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        fetchPhotosWithTags(tags, location: nil, page: page, completionBlock: completionBlock)
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, location: CLLocationCoordinate2D?, page: Int, completionBlock: (response: APIResponse?, error: NSError?) -> Void) {
        let tagsString = tags.joinWithSeparator(",")
        let arguments: [CVarArgType]
        let format: String
        if let coordinate = location {
            format = FlickrAPI.TagsAndGeoSearchFormat
            arguments = [tagsString, FlickrAPIClient.FlickrAPIKey, page, coordinate.latitude, coordinate.longitude]
        }
        else {
            format = FlickrAPI.TagsSearchFormat
            arguments = [tagsString, FlickrAPIClient.FlickrAPIKey, page]
        }
        let photosURL = String(format: format, arguments: arguments)
        
        performRequest(.GET, URLString: photosURL) { [weak self] response -> Void in
            if let error = response.result.error {
                completionBlock(response: nil, error: error)
            }
            else if let jsonObject = response.result.value as? [String : AnyObject] {
                var photoParser: PhotoParser? = nil
                if let strongSelf = self {
                    photoParser = strongSelf.parser
                }
                let status = jsonObject["stat"] as? String
                if let status = status {
                    if status == "fail" {
                        let message = jsonObject["message"] as! String
                        let code = jsonObject["code"] as! Int
                        let userInfo = [NSLocalizedDescriptionKey: message, NSUnderlyingErrorKey: jsonObject.description]
                        let apiError = NSError(domain: FlickrAPIClient.FlickrAPIDomain, code: code, userInfo: userInfo)
                        completionBlock(response: nil, error: apiError)
                    }
                    else if let photoParser = photoParser {
                        let metadata = photoParser.parseMetadata(jsonObject)
                        let photos = photoParser.parsePhotos(jsonObject)
                        let response = APIResponse(metadata: metadata, responseObject: photos)
                        completionBlock(response: response, error: nil)
                    }
                }
                else {
                    completionBlock(response: nil, error: nil)
                }
            }
        }
        
    }
    
    public func performRequest(method: Alamofire.Method, URLString: URLStringConvertible, completionHandler: (Response<AnyObject, NSError>) -> Void) {
        print("- Perofming request with URL \(URLString)")
        Alamofire.request(method, URLString).responseJSON(options: .AllowFragments, completionHandler: completionHandler)
    }
   
}
