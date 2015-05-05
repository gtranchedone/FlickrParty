//
//  PhotoCollectionViewCell.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 05/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
 
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.frame = self.contentView.bounds
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    override func prepareForReuse() {
        imageView.image = nil;
        super.prepareForReuse()
    }
    
}
