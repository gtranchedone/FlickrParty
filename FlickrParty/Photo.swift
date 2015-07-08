//
//  Photo.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import Haneke

public class Photo : Equatable, DebugPrintable, DataConvertible, DataRepresentable {
    
    public let imageURL: NSURL?
    public let thumbnailURL: NSURL?
    
    public let title: String
    public let ownerName: String
    public let identifier: String
    public let description: String
    
    public var debugDescription: String {
        get {
            return dictionaryValue().debugDescription
        }
    }
    
    public init(identifier: String, title: String, description: String, ownerName: String, imageURL: NSURL?, thumbnailURL: NSURL?) {
        self.title = title
        self.ownerName = ownerName
        self.identifier = identifier;
        self.description = description;
        self.imageURL = imageURL;
        self.thumbnailURL = thumbnailURL;
    }
    
    public func dictionaryValue() -> Dictionary<String, String> {
        let imageURLString = (imageURL == nil) ? "" : imageURL!.description
        let thumbnailURLString = (thumbnailURL == nil) ? "" : thumbnailURL!.description
        return ["identifier": identifier,
                "title": title,
                "ownerName": ownerName,
                "description": description,
                "imageURL": imageURLString,
                "thumbnailURL": thumbnailURLString]
    }
    
    // MARK: DataConvertible
    
    public static func convertFromData(data: NSData) -> Photo? {
        if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil) as? Dictionary<String, String> {
            let identifier = dictionary["identifier"]!
            let title = dictionary["title"]!
            let description = dictionary["description"]!
            let ownerName = dictionary["ownerName"]!
            let imageURLString = (dictionary["imageURL"] != nil) ? dictionary["imageURL"]! : ""
            let thumbnailURLString = (dictionary["thumbnailURL"] != nil) ? dictionary["thumbnailURL"]! : ""
            let imageURL = NSURL(string: imageURLString)
            let thumbnailURL = NSURL(string: thumbnailURLString)
            return Photo(identifier: identifier, title: title, description: description, ownerName: ownerName, imageURL: imageURL, thumbnailURL: thumbnailURL)
        }
        else {
            return nil
        }
    }
    
    // MARK: DataRepresentable
    
    public func asData() -> NSData! {
        return NSJSONSerialization.dataWithJSONObject(dictionaryValue(), options: NSJSONWritingOptions.PrettyPrinted, error: nil)!
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
