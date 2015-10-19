//
//  NearbyPartyPhotosViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 08/07/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import CoreLocation

// This is an example of how you could specialize PhotosViewController to have specific logic and a specific dataSource
// so that the class can be aware of it and manipulate the info required by the dataSource in order to operate correctly.
public class NearbyPartyPhotosViewController: PhotosViewController, CLLocationManagerDelegate {

    public var locationManager = CLLocationManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if (dataSource == nil) {
            dataSource = NearbyPartyPhotosDataSource(apiClient: FlickrAPIClient())
        }
        locationManager.delegate = self
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        askForUseLocationServiceIfNeeded()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // if the user location wasn't found yet, stop when the viewController isn't active anymore
        locationManager.stopUpdatingLocation()
    }
    
    private func askForUseLocationServiceIfNeeded() {
        // using the dynamicType ensures that we use the method from any subclass of CLLocationManager
        let authorizationStatus = locationManager.dynamicType.authorizationStatus()
        switch (authorizationStatus) {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            default:
                // update the view
                locationManager(locationManager, didChangeAuthorizationStatus: authorizationStatus)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
                backgroundView.textLabel.text = nil
            }
            // get the latest user location
            if (dataSource?.numberOfItems() <= 0) {
                locationManager.startUpdatingLocation()
            }
            
        case .Denied, .Restricted:
            self.dataSource?.invalidateContent() // reset the collectionView's content if it was populated by then the permissions changed
            if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
                backgroundView.textLabel.text = "You've denied usage of location services, therefore we're unable to show you photos of nearby parties"
            }
            
        case .NotDetermined:
            // do nothing
            break
        }
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let dataSource = dataSource as? NearbyPartyPhotosDataSource {
            // if a location is found, stop getting location updates and update the dataSource
            if let location = locations.first {
                dataSource.locationCoordinate = location.coordinate
                manager.stopUpdatingLocation()
            }
        }
        reloadData()
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if let backgroundView = self.collectionView?.backgroundView as? CollectionBackgroundView {
            backgroundView.activityIndicator.stopAnimating()
            backgroundView.textLabel.text = "Sorry, your location cannot be determined. Please try again later."
        }
    }
    
}
