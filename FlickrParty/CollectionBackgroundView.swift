//
//  CollectionBackgroundView.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class CollectionBackgroundView: UIView {

    lazy public var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        let originX = (self.bounds.size.width - activityIndicator.bounds.size.width) / 2.0
        let originY = (self.bounds.size.height - activityIndicator.bounds.size.height) / 2.0
        activityIndicator.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: activityIndicator.bounds.size)
        activityIndicator.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
