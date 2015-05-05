//
//  Photo.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class Photo : Equatable {
    
    let imageURL: NSURL?
    let thumbnailURL: NSURL?
    
    let title: String
    let ownerName: String
    let identifier: String
    let description: String
    
    public init(identifier: String, title: String, description: String, ownerName: String, imageURL: NSURL?, thumbnailURL: NSURL?) {
        self.title = title
        self.ownerName = ownerName
        self.identifier = identifier;
        self.description = description;
        self.imageURL = imageURL;
        self.thumbnailURL = thumbnailURL;
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
