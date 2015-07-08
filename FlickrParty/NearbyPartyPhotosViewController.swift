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
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        askForUseLocationServiceIfNeeded()
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
                reloadData()
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
    
}
