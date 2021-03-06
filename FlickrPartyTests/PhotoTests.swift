//
//  PhotoTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class PhotoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTwoDifferentPhotosAreNotEqual() {
        let photo1 = Photo(identifier: "photo1", title: "", details: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        let photo2 = Photo(identifier: "photo2", title: "", details: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        XCTAssertNotEqual(photo1, photo2, "Two different Photos are believed to be equal")
    }
    
    func testTwoPhotosAreEqualIfIdentifiersAreEqual() {
        let photo1 = Photo(identifier: "photo", title: "", details: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        let photo2 = Photo(identifier: "photo", title: "", details: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        XCTAssertEqual(photo1, photo2, "Two supposedly equal Photos aren't recognized as equal")
    }
    
    func testPhotoCanBeConvertedToDictionary() {
        let photo = makePhoto()
        let dictionaryValue = photo.dictionaryValue()
        let expectedDictionary = makePhotoDictionary()
        XCTAssertEqual(expectedDictionary, dictionaryValue)
    }
    
    func testPhotoWithNoURLsCanBeConvertedToDictionary() {
        let photo = makePhotoWithNoURLs()
        let dictionaryValue = photo.dictionaryValue()
        let expectedDictionary = makePhotoDictionaryWithNoURLs()
        XCTAssertEqual(expectedDictionary, dictionaryValue)
    }
    
    func testPhotoCanBePrintedInConsoleWithMeaningfulDescription() {
        let photo = makePhoto()
        let dictionaryValue = photo.dictionaryValue()
        XCTAssertEqual(photo.description, dictionaryValue.description)
    }
    
    func testPhotoImplementsDataRepresentableProtocolCorrectly() {
        let photo = makePhoto()
        let dataValue = photo.asData()
        let dictionaryValue = photo.dictionaryValue()
        let dataAsDictionary = try! NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions.AllowFragments) as? [String : String]
        XCTAssertEqual(dictionaryValue, dataAsDictionary!, "Photo doesn't implement the DataRepresentable protocol correctly")
    }
    
    func testPhotoImplementsDataConvertibleProtocolCorrectly() {
        let photo = makePhoto()
        var photoDictionary = makePhotoDictionary()
        photoDictionary["description"] = photoDictionary["details"]
        let photoDictionaryData = try! NSJSONSerialization.dataWithJSONObject(photoDictionary, options: NSJSONWritingOptions.PrettyPrinted)
        let convertedPhoto = Photo.convertFromData(photoDictionaryData)
        XCTAssertEqual(photo, convertedPhoto!, "Photo doesn't implement the DataRepresentable protocol correctly")
    }
    
    private func makePhoto() -> Photo {
        let imageURL = NSURL(string: "https://apple.com/imageURL.jpg")
        let thumbnailURL = NSURL(string: "https://apple.com/thumbnailURL.jpg")
        let photo = Photo(identifier: "123", title: "Photo 123", details: "Some Description", ownerName: "Some Owner", imageURL: imageURL, thumbnailURL: thumbnailURL)
        return photo
    }
    
    private func makePhotoWithNoURLs() -> Photo {
        let photo = Photo(identifier: "123", title: "Photo 123", details: "Some Description", ownerName: "Some Owner")
        return photo
    }

    private func makePhotoDictionary() -> [String: String] {
        return ["identifier": "123",
                "title": "Photo 123",
                "details": "Some Description",
                "ownerName": "Some Owner",
                "imageURL": "https://apple.com/imageURL.jpg",
                "thumbnailURL": "https://apple.com/thumbnailURL.jpg"]
    }
    
    private func makePhotoDictionaryWithNoURLs() -> [String: String] {
        return ["identifier": "123",
            "title": "Photo 123",
            "details": "Some Description",
            "ownerName": "Some Owner",
            "imageURL": "",
            "thumbnailURL": ""]
    }
    
}
