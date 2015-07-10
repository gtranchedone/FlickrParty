//
//  FlickrAPIClientTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty

class FlickrAPIClientTests: XCTestCase {

    var apiClient: FlickrAPIClient?
    
    override func setUp() {
        super.setUp()
        apiClient = FlickrAPIClient()
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    // TODO: Test me!!

}
