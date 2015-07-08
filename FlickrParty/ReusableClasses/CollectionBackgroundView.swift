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
    
    lazy public var textLabel: UILabel = {
        let label = UILabel(frame: CGRectInset(self.bounds, 20.0, 20.0))
        label.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Center
        label.numberOfLines = 0
        self.addSubview(label)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
