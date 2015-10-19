//
//  PhotoCollectionViewCell.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 05/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class PhotoCollectionViewCell: UICollectionViewCell {
 
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = self.contentView.bounds
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func prepareForReuse() {
        imageView.image = nil;
        super.prepareForReuse()
    }
    
}
