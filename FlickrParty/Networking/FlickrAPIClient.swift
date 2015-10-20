//
//  FlickrAPIClient.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Alamofire
import CoreLocation

extension Request: APIRequest {
}

extension Manager: APIRequestManager {
    
    public func makeRequest(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers: [String : String]?) -> APIRequest {
        return request(method, URLString, parameters: parameters, encoding: encoding, headers: headers)
    }
    
}

public class FlickrAPIClient: APIClient {
    
    public var parser: PhotoParser
    public var networkingManager: APIRequestManager = Manager.sharedInstance
    
    struct FlickrAPI {
        static let APIDomain = "FlickrAPIDomain"
        static let APIKey = "31eb1c7d7d8532ac0493443606bbce13"
        
        static let TagsSearchFormat = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&tags=%@&extras=description,owner_name,url_s,url_l,url_o&api_key=%@&page=%d"
        static let TagsAndGeoSearchFormat = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&tags=%@&extras=description,owner_name,url_s,url_l,url_o,geo&has_geo=1&api_key=%@&page=%d&lat=%f&long=%f"
    }
    
    struct FlickerAPIMetadataKeys {
        static let Status = "stat"
        static let FailedStatusValue = "fail"
        static let FailureStatusMessage = "message"
        static let FailureStatusCode = "code"
    }
    
    public init(parser: PhotoParser = FlickrPhotoParser()) {
        self.parser = parser
    }
    
    public func fetchPhotosWithTags(tags: Array<String>, page: Int = 1, completionBlock: APIClientCompletionBlock) {
        fetchPhotosWithTags(tags, location: nil, page: page, completionBlock: completionBlock)
    }
    
    public func fetchPhotosWithTags(tags: [String], location: CLLocationCoordinate2D?, page: Int, completionBlock: APIClientCompletionBlock) {
        let tagsString = tags.joinWithSeparator(",")
        let arguments: [CVarArgType]
        let format: String
        if let coordinate = location {
            format = FlickrAPI.TagsAndGeoSearchFormat
            arguments = [tagsString, FlickrAPI.APIKey, page, coordinate.latitude, coordinate.longitude]
        }
        else {
            format = FlickrAPI.TagsSearchFormat
            arguments = [tagsString, FlickrAPI.APIKey, page]
        }
        let photosURL = String(format: format, arguments: arguments)
        
        performRequest(.GET, URLString: photosURL) { [weak self] response -> Void in
            if let strongSelf = self {
                strongSelf.parseAPIResponse(response, completionBlock: completionBlock)
            }
        }
        
    }
    
    public func performRequest(method: Alamofire.Method, URLString: URLStringConvertible, completionHandler: (Response<AnyObject, NSError>) -> Void) {
        print("- Perofming request with URL \(URLString)")
        let request = networkingManager.makeRequest(method, URLString, parameters: nil, encoding: .URL, headers: nil)
        request.responseJSON(options: .AllowFragments, completionHandler: completionHandler)
    }
    
    private func parseAPIResponse(response: Response<AnyObject, NSError>, completionBlock: (response: APIResponse?, error: NSError?) -> ()) {
        var finalError: NSError?
        var finalResponse: APIResponse?
        defer { completionBlock(response: finalResponse, error: finalError) }
        guard response.result.error == nil else {
            finalError = response.result.error
            return
        }
        
        if let jsonObject = response.result.value as? [String : AnyObject] {
            let status = jsonObject[FlickerAPIMetadataKeys.Status] as? String
            if let status = status {
                if status == FlickerAPIMetadataKeys.FailedStatusValue {
                    let code = jsonObject[FlickerAPIMetadataKeys.FailureStatusCode] as! Int
                    let message = jsonObject[FlickerAPIMetadataKeys.FailureStatusMessage] as! String
                    let userInfo = [NSLocalizedDescriptionKey: message, NSUnderlyingErrorKey: jsonObject.description]
                    finalError = NSError(domain: FlickrAPI.APIDomain, code: code, userInfo: userInfo)
                }
                else {
                    let metadata = parser.parseMetadata(jsonObject)
                    let photos = parser.parsePhotos(jsonObject)
                    finalResponse = APIResponse(metadata: metadata, responseObject: photos)
                }
            }
        }
    }
   
}
