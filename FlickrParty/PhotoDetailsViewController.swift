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

    var photo: Photo?
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    let imageCache = Cache<UIImage>(name: "PhotoDetailsImageCache")
    
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
    }
    
    private func loadPhotoIfNeeded() {
        if imageView.image != nil {
            return // Don't try to load an image that was already loaded
        }
        if let imageURL = photo?.imageURL {
            let imageFetcher = NetworkFetcher<UIImage>(URL: imageURL)
            imageCache.fetch(fetcher: imageFetcher).onSuccess { [weak self] image in
                self?.imageView.image = image;
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
