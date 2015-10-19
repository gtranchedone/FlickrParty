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
    
    struct FlickerAPIMetadataKeys {
        static let Status = "stat"
        static let FailedStatusValue = "fail"
        static let FailureStatusMessage = "message"
        static let FailureStatusCode = "code"
    }
    
    public convenience init() {
        self.init(parser: FlickrPhotoParser())
    }
    
    public init(parser: PhotoParser?) {
        self.parser = parser
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, page: Int = 1, completionBlock: (response: APIResponse?, error: NSError?) -> ()) {
        fetchPhotosWithTags(tags, location: nil, page: page, completionBlock: completionBlock)
    }
    
    public func fetchPhotosWithTags(tags: [String], location: CLLocationCoordinate2D?, page: Int, completionBlock: (response: APIResponse?, error: NSError?) -> ()) {
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
                if let strongSelf = self {
                    strongSelf.parseAPIResponse(response, completionBlock: completionBlock)
                }
                else {
                    completionBlock(response: nil, error: error)
                }
            }
        }
        
    }
    
    func parseAPIResponse(response: Response<AnyObject, NSError>, completionBlock: (response: APIResponse?, error: NSError?) -> ()) {
        guard parser != nil else { return }
        if let jsonObject = response.result.value as? [String : AnyObject] {
            let status = jsonObject[FlickerAPIMetadataKeys.Status] as? String
            if let status = status {
                if status == FlickerAPIMetadataKeys.FailedStatusValue {
                    let code = jsonObject[FlickerAPIMetadataKeys.FailureStatusCode] as! Int
                    let message = jsonObject[FlickerAPIMetadataKeys.FailureStatusMessage] as! String
                    let userInfo = [NSLocalizedDescriptionKey: message, NSUnderlyingErrorKey: jsonObject.description]
                    let apiError = NSError(domain: FlickrAPIClient.FlickrAPIDomain, code: code, userInfo: userInfo)
                    completionBlock(response: nil, error: apiError)
                }
                else {
                    let metadata = parser!.parseMetadata(jsonObject)
                    let photos = parser!.parsePhotos(jsonObject)
                    let response = APIResponse(metadata: metadata, responseObject: photos)
                    completionBlock(response: response, error: nil)
                }
            }
            else {
                completionBlock(response: nil, error: nil)
            }
        }
    }
    
    public func performRequest(method: Alamofire.Method, URLString: URLStringConvertible, completionHandler: (Response<AnyObject, NSError>) -> Void) {
        print("- Perofming request with URL \(URLString)")
        Alamofire.request(method, URLString).responseJSON(options: .AllowFragments, completionHandler: completionHandler)
    }
   
}
