//
//  Photo.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import Haneke

public class Photo : Equatable, CustomStringConvertible, DataConvertible, DataRepresentable {
    
    public let imageURL: NSURL?
    public let thumbnailURL: NSURL?
    
    public let title: String
    public let details: String
    public let ownerName: String
    public let identifier: String
    
    public var description: String {
        get {
            return dictionaryValue().description
        }
    }
    
    public init(identifier: String, title: String, details: String, ownerName: String, imageURL: NSURL? = nil, thumbnailURL: NSURL? = nil) {
        self.title = title
        self.ownerName = ownerName
        self.identifier = identifier
        self.details = details
        self.imageURL = imageURL
        self.thumbnailURL = thumbnailURL
    }
    
    public func dictionaryValue() -> Dictionary<String, String> {
        let imageURLString = (imageURL == nil) ? "" : imageURL!.description
        let thumbnailURLString = (thumbnailURL == nil) ? "" : thumbnailURL!.description
        return ["identifier": identifier,
                "title": title,
                "details": details,
                "ownerName": ownerName,
                "imageURL": imageURLString,
                "thumbnailURL": thumbnailURLString]
    }
    
    // MARK: DataConvertible
    
    public static func convertFromData(data: NSData) -> Photo? {
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let dictionary = result as? [String : String] {
                let identifier = dictionary["identifier"]!
                let title = dictionary["title"] ?? ""
                let description = dictionary["description"] ?? ""
                let ownerName = dictionary["ownerName"]!
                let imageURLString = dictionary["imageURL"] ?? ""
                let thumbnailURLString = dictionary["thumbnailURL"] ?? ""
                let imageURL = NSURL(string: imageURLString)
                let thumbnailURL = NSURL(string: thumbnailURLString)
                return Photo(identifier: identifier, title: title, details: description, ownerName: ownerName, imageURL: imageURL, thumbnailURL: thumbnailURL)
            }
        }
        catch {
            print("An error has occurred: -> \(error)") // TODO: improve error handling
        }
        return nil
    }
    
    // MARK: DataRepresentable
    
    public func asData() -> NSData! {
        return try! NSJSONSerialization.dataWithJSONObject(dictionaryValue(), options: NSJSONWritingOptions.PrettyPrinted)
    }
    
}

public func ==(lhs: Photo, rhs: Photo) -> Bool {
    // NOTE: checking only identifier would be quicker, but like so it's more convenient for testing
    return (lhs.identifier == rhs.identifier &&
            lhs.imageURL == rhs.imageURL &&
            lhs.thumbnailURL == rhs.thumbnailURL &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.ownerName == rhs.ownerName)
}
