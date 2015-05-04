//
//  PhotosDataSource.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 04/05/2015.
//  Copyright (c) 2015 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class PhotosDataSource: ViewDataSource {
   
    override public func fetchContent() {
        if let apiClient = self.apiClient {
            apiClient.fetchPhotosWithTags(nil) { [unowned self] possibleError in
                if let error = possibleError {
                    self.delegate?.viewDataSourceDidFailFetchingContent(self, error: error)
                }
                else {
                    self.delegate?.viewDataSourceDidFetchContent(self)
                }
            }
        }
    }
    
}
