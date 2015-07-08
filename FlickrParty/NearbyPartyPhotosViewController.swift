//
//  NearbyPartyPhotosViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import CoreLocation

public class NearbyPartyPhotosViewController: PhotosViewController, CLLocationManagerDelegate {

    public var locationManager = CLLocationManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = NearbyPartyPhotosDataSource(apiClient: FlickrAPIClient())
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        askForUseLocationServiceIfNeeded()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func askForUseLocationServiceIfNeeded() {
        locationManager.delegate = self
        let authorizationStatus = locationManager.dynamicType.authorizationStatus()
        switch (authorizationStatus) {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            default:
                locationManager(locationManager, didChangeAuthorizationStatus: authorizationStatus)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
                backgroundView.textLabel.text = nil
                if (dataSource?.numberOfItems() <= 0) {
                    locationManager.startUpdatingLocation()
                }
            }
            
        case .Denied, .Restricted:
            if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
                backgroundView.textLabel.text = "You've denied usage of location services, therefore we're unable to show you photos of nearby parties"
                self.dataSource?.invalidateContent()
            }
            
        case .NotDetermined:
            break
        }
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let dataSource = dataSource as? NearbyPartyPhotosDataSource {
            if let location = locations.first as? CLLocation {
                dataSource.locationCoordinate = location.coordinate
                manager.stopUpdatingLocation()
            }
        }
        reloadData()
    }
    
    public func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.activityIndicator.stopAnimating()
            backgroundView.textLabel.text = "Sorry, your location cannot be determined. Please try again later."
        }
    }
    
}
