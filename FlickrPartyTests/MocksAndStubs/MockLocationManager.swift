//
//  MockLocationManager.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 10/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import CoreLocation

class MockLocationManager: CLLocationManager {
    
    static var stubAuthorizationStatus = CLAuthorizationStatus.NotDetermined
    var didAskForInUseAuthorization = false
    var didStopUpdatingLocation = false
    var shouldFail = false
    
    override class func authorizationStatus() -> CLAuthorizationStatus {
        return stubAuthorizationStatus
    }
    
    override func requestWhenInUseAuthorization() {
        didAskForInUseAuthorization = true
    }
    
    override func startUpdatingLocation() {
        if shouldFail {
            delegate?.locationManager?(self, didFailWithError: NSError(domain: "stubs domain", code: 404, userInfo: nil))
        }
        else {
            delegate?.locationManager?(self, didUpdateLocations: [])
        }
    }
    
    override func stopUpdatingLocation() {
        didStopUpdatingLocation = true
    }
    
}
