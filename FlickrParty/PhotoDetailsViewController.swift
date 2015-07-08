//
//  PhotoDetailsViewController.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 05/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import Haneke

public class PhotoDetailsViewController: UIViewController, UIScrollViewDelegate {

    public var photo: Photo?
    public let imageView = UIImageView()
    public let scrollView = UIScrollView()
    public let imageCache = Cache<UIImage>(name: "PhotoDetailsImageCache")
    public let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    public init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpImageView()
        setUpView()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        loadPhotoIfNeeded()
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Helpers
    
    private func setUpScrollView() {
        scrollView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.frame = self.view.bounds
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    private func setUpImageView() {
        imageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = scrollView.bounds
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
    }
    
    private func setUpView() {
        title = photo?.title
        view.backgroundColor = UIColor.whiteColor()
        view.insertSubview(activityIndicator, belowSubview: scrollView)
        activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        let centerXContraint = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: activityIndicator, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerYContraint = NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: activityIndicator, attribute: .CenterY, multiplier: 1, constant: 0)
        view.addConstraints([centerXContraint, centerYContraint])
    }
    
    private func loadPhotoIfNeeded() {
        if imageView.image != nil {
            return // Don't try to load an image that was already loaded
        }
        if let imageURL = photo?.imageURL {
            activityIndicator.startAnimating()
            let imageFetcher = NetworkFetcher<UIImage>(URL: imageURL)
            imageCache.fetch(fetcher: imageFetcher).onSuccess { [weak self] image in
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image;
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
