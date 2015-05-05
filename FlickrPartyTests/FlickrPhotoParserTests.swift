//
//  FlickrPhotoParserTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class FlickrPhotoParserTests: XCTestCase {

    var parser: FlickrPhotoParser?
    
    override func setUp() {
        super.setUp()
        parser = FlickrPhotoParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    private func parseSamplePhotos() -> Array<Photo> {
        let filePath = NSBundle(forClass: FlickrAPIClientTests.self).pathForResource("FlickrSearchAPIResponse", ofType: "json")
        let sampleData = NSData(contentsOfFile: filePath!)
        let jsonObject = NSJSONSerialization.JSONObjectWithData(sampleData!, options: .AllowFragments, error: nil) as? Dictionary<String, AnyObject>
        let parsedPhotos = parser!.parsePhotos(jsonObject!)
        return parsedPhotos
    }

    func testReturnsEmptyArrayWhenNoPhotoIsFound() {
        let parsedPhotos = parser!.parsePhotos([])
        XCTAssertEqual(0, parsedPhotos.count, "If no Photo is found the parser should return an empty array")
    }
    
    func testReturnsCorrectNumberOfPhotosFromSampleData() {
        let parsedPhotos = parseSamplePhotos()
        XCTAssertEqual(100, parsedPhotos.count, "Unexpected number of parsed Photos")
    }
    
    func testReturnsCorrectFirstPhoto() {
        let expectedPhoto = Photo(identifier: "17373877915", title: "", description: "", ownerName: "BTKoch", imageURL: NSURL(string: "https://farm8.staticflickr.com/7698/17373877915_29a85fab82_l.jpg")!, thumbnailURL: NSURL(string: "https://farm8.staticflickr.com/7698/17373877915_8197c96856_m.jpg")!)
        let parsedPhotos = parseSamplePhotos()
        let actualPhoto = parsedPhotos.first!
        XCTAssertEqual(expectedPhoto, actualPhoto, "Parser didn't correctly parse first photo")
    }
    
    func testReturnsCorrectLastPhoto() {
        let expectedPhoto = Photo(identifier: "17344959276", title: "Spring Banquet 2015 - Photo Booth", description: "Pictures from Hannah\nThe Majestic in Abilene, Texas", ownerName: "klar_rocks", imageURL: NSURL(string: "https://farm8.staticflickr.com/7698/17344959276_a8d583e9b3_o.jpg")!, thumbnailURL: NSURL(string: "https://farm8.staticflickr.com/7698/17344959276_bee2b0d2ba_m.jpg")!)
        let parsedPhotos = parseSamplePhotos()
        let actualPhoto = parsedPhotos.last!
        XCTAssertEqual(expectedPhoto, actualPhoto, "Parser didn't correctly parse last photo")
    }

}
