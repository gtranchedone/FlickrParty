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
        let expectedPhoto = Photo(identifier: "17182996929", title: "Kod kuma Francuza (02.05.2015)", description: "Noćni provod u Boru - Kod kuma Francuza", ownerName: "www.bor030.net", imageURL: NSURL(string: "https://farm8.staticflickr.com/7758/17182996929_169bb08636_o.jpg")!, thumbnailURL: NSURL(string: "https://farm8.staticflickr.com/7758/17182996929_64fb30c111_t.jpg")!)
        let parsedPhotos = parseSamplePhotos()
        let actualPhoto = parsedPhotos.first!
        XCTAssertEqual(expectedPhoto, actualPhoto, "Parser didn't correctly parse first photo")
    }
    
    func testReturnsCorrectLastPhoto() {
        let expectedPhoto = Photo(identifier: "16746460784", title: "Kod kuma Francuza (01.05.2015)", description: "Noćni provod u Boru - Kod kuma Francuza", ownerName: "www.bor030.net", imageURL: NSURL(string: "https://farm8.staticflickr.com/7760/16746460784_5d45560147_o.jpg")!, thumbnailURL: NSURL(string: "https://farm8.staticflickr.com/7760/16746460784_1a5dc3ab73_t.jpg")!)
        let parsedPhotos = parseSamplePhotos()
        let actualPhoto = parsedPhotos.last!
        XCTAssertEqual(expectedPhoto, actualPhoto, "Parser didn't correctly parse last photo")
    }

}
