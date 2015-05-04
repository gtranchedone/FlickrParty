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
        let photo1 = Photo(identifier: "photo1", title: "", description: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        let photo2 = Photo(identifier: "photo2", title: "", description: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        XCTAssertNotEqual(photo1, photo2, "Two different Photos are believed to be equal")
    }
    
    func testTwoPhotosAreEqualIfIdentifiersAreEqual() {
        let photo1 = Photo(identifier: "photo", title: "", description: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        let photo2 = Photo(identifier: "photo", title: "", description: "", ownerName: "", imageURL: NSURL(string: "apple.com")!, thumbnailURL: NSURL(string: "apple.com")!)
        XCTAssertEqual(photo1, photo2, "Two supposedly equal Photos aren't recognized as equal")
    }

}
