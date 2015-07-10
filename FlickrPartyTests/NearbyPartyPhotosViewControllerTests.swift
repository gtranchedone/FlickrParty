//
//  NearbyPartyPhotosViewControllerTests.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
import FlickrParty
import CoreLocation

class NearbyPartyPhotosViewControllerTests: XCTestCase {

    var viewController: NearbyPartyPhotosViewController?
    
    override func setUp() {
        super.setUp()
        viewController = NearbyPartyPhotosViewController()
        viewController?.locationManager = MockLocationManager()
        viewController?.dataSource = MockNearbyPartyPhotosDataSource()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    // MARK: Location Permissions Updates
    
    func testAsksUserForLocationPermissionsWhenViewAppearsIfNotAskedBefore() {
        let mockLocationManager = viewController?.locationManager as! MockLocationManager
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.endAppearanceTransition()
        XCTAssertTrue(mockLocationManager.didAskForInUseAuthorization, "Did not ask for location service 'while in use' permissions")
    }
    
    func testDoesNotAskUserForLocationPermissionsWhenViewAppearsIfDidAskBefore() {
        let mockLocationManager = viewController?.locationManager as! MockLocationManager
        mockLocationManager.dynamicType.stubAuthorizationStatus = .AuthorizedWhenInUse
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.endAppearanceTransition()
        XCTAssertFalse(mockLocationManager.didAskForInUseAuthorization, "Did ask for location service 'while in use' permissions twice")
    }
    
    func testDisplaysAnAppropriateMessageIfUserDeniedPermissionsToUseLocation() {
        let mockLocationManager = viewController?.locationManager as! MockLocationManager
        mockLocationManager.dynamicType.stubAuthorizationStatus = .Denied
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.endAppearanceTransition()
        if let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView {
            let expectedMessage = "You've denied usage of location services, therefore we're unable to show you photos of nearby parties"
            if let message = backgroundView.textLabel.text {
                XCTAssertEqual(message, expectedMessage, "Isn't showing the expected message to users who deny usage of location service")
            }
            else {
                XCTFail("Isn't showing the expected message to users who deny usage of location service")
            }
        }
        else {
            XCTFail("Doesn't have an appropriate backgroundView to display messages")
        }
    }
    
    func testDisplaysAnAppropriateMessageIfUserChangesPermissionsToUseLocationToDenied() {
        updateLocationAuthorizationStatusFromAuthorizedToDenied(false)
        if let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView {
            let expectedMessage = "You've denied usage of location services, therefore we're unable to show you photos of nearby parties"
            if let message = backgroundView.textLabel.text {
                XCTAssertEqual(message, expectedMessage, "Isn't showing the expected message to users who deny usage of location service")
            }
            else {
                XCTFail("Isn't showing the expected message to users who deny usage of location service")
            }
        }
        else {
            XCTFail("Doesn't have an appropriate backgroundView to display messages")
        }
    }
    
    func testDoesNotDisplayAnyMessageIfUserChangesPermissionsToUseLocationToAuthorized() {
        updateLocationAuthorizationStatusFromDeniedToAuthorized(false)
        if let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView {
            let expectedMessage = "You've denied usage of location services, therefore we're unable to show you photos of nearby parties"
            XCTAssertNil(backgroundView.textLabel.text, "Is showing an unappropriate message to users who allow usage of location service")
        }
        else {
            XCTFail("Doesn't have an appropriate backgroundView to display messages")
        }
    }
    
    func testInvalidatesPhotosIfUserChangesPermissionsToUseLocationToDenied() {
        viewController?.dataSource = MockDataSource()
        updateLocationAuthorizationStatusFromAuthorizedToDenied(true)
        let mockDataSource = viewController?.dataSource as! MockDataSource
        XCTAssertTrue(mockDataSource.didInvalidate, "Did not invalidate dataSource when authorization for using location service changed to 'denied'")
    }
    
    func testReloadsPhotosIfUserChangesPermissionsToUseLocationToAuthorized() {
        updateLocationAuthorizationStatusFromDeniedToAuthorized(true)
        let mockDataSource = viewController?.dataSource as! MockDataSource
        XCTAssertTrue(mockDataSource.loading, "Did not ask dataSource to reload data when authorization for using location service changed to 'authorized'")
    }
    
    func testDisplaysAnAppropriateMessageIfUserLocationIsUnavailable() {
        let mockLocationManager = viewController?.locationManager as! MockLocationManager
        mockLocationManager.dynamicType.stubAuthorizationStatus = .AuthorizedWhenInUse
        mockLocationManager.shouldFail = true
        
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.endAppearanceTransition()
        
        if let backgroundView = viewController?.collectionView?.backgroundView as? CollectionBackgroundView {
            let expectedMessage = "Sorry, your location cannot be determined. Please try again later."
            XCTAssertFalse(backgroundView.activityIndicator.isAnimating(), "Shouldn't be showing the activity indicator anymore")
            if let message = backgroundView.textLabel.text {
                XCTAssertEqual(message, expectedMessage, "Isn't showing the expected message to users whose location cannot be determined")
            }
            else {
                XCTFail("Isn't showing the expected message to users who deny usage of location service")
            }
        }
        else {
            XCTFail("Doesn't have an appropriate backgroundView to display messages")
        }
    }
    
    func testStopsLocationUpdatesWhenUserLocationIsFound() {
        let locationManager = viewController?.locationManager as! MockLocationManager
        viewController?.locationManager(locationManager, didUpdateLocations: [CLLocation(latitude: 0.0, longitude: 0.0)])
        XCTAssertTrue(locationManager.didStopUpdatingLocation, "Didn't stop location updates once the user's location is determined")
    }
    
    func testStopsLocationUpdatesWhenViewIsDisappearing() {
        let locationManager = viewController?.locationManager as! MockLocationManager
        viewController?.beginAppearanceTransition(false, animated: false)
        viewController?.endAppearanceTransition()
        XCTAssertTrue(locationManager.didStopUpdatingLocation, "Didn't stop location updates once the user's location is determined")
    }
    
    // MARK: Data Source
    
    func testDataSourceIsNotReplacedIfPreviouslySet() {
        viewController?.beginAppearanceTransition(true, animated: false)
        XCTAssertTrue(viewController?.dataSource is MockNearbyPartyPhotosDataSource, "Preset dataSource is getting replaced when the view is loaded or appearing")
    }
    
    func testDataSourceIsNearbyPartyPhotosDataSource() {
        viewController?.dataSource = nil
        viewController?.beginAppearanceTransition(true, animated: false)
        XCTAssertTrue(viewController?.dataSource is NearbyPartyPhotosDataSource, "Default dataSource isn't of the expected type")
    }
    
    func testUpdatesDataSourceWhenUserLocationIsFound() {
        viewController?.locationManager(viewController?.locationManager, didUpdateLocations: [CLLocation(latitude: 10.0, longitude: 10.0)])
        let dataSource = viewController?.dataSource as! MockNearbyPartyPhotosDataSource
        if let coordinate = dataSource.locationCoordinate {
            XCTAssertEqual(coordinate.latitude, 10.0, "The dataSource wasn't updated when the user location was determined")
        }
        else {
            XCTFail("The dataSource wasn't updated when the user location was determined")
        }
    }
    
    // MARK: Private
    
    func updateLocationAuthorizationStatusFromAuthorizedToDenied(rebuildDataSource: Bool) {
        let mockLocationManager = viewController?.locationManager as! MockLocationManager
        mockLocationManager.dynamicType.stubAuthorizationStatus = .AuthorizedWhenInUse
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.endAppearanceTransition()
        if (rebuildDataSource) {
            viewController?.dataSource = MockDataSource()
        }
        mockLocationManager.dynamicType.stubAuthorizationStatus = .Denied
        mockLocationManager.delegate?.locationManager?(mockLocationManager, didChangeAuthorizationStatus: .Denied)
    }

    func updateLocationAuthorizationStatusFromDeniedToAuthorized(rebuildDataSource: Bool) {
        let mockLocationManager = viewController?.locationManager as! MockLocationManager
        mockLocationManager.dynamicType.stubAuthorizationStatus = .Denied
        viewController?.beginAppearanceTransition(true, animated: false)
        viewController?.endAppearanceTransition()
        if (rebuildDataSource) {
            viewController?.dataSource = MockDataSource()
        }
        mockLocationManager.dynamicType.stubAuthorizationStatus = .AuthorizedWhenInUse
        mockLocationManager.delegate?.locationManager?(mockLocationManager, didChangeAuthorizationStatus: .AuthorizedWhenInUse)
    }
    
}
