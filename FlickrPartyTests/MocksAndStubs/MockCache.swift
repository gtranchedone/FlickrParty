//
//  MockPhotoCache.swift
//  FlickrParty
//
//  Created by Gianluca Tranchedone on 20/10/2015.
//  Copyright © 2015 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import Haneke

class MockCache<T: DataConvertible where T.Result == T, T : DataRepresentable>: Cache<T> {
    
    var needsToFail = false
    var error: NSError?
    var item: T?
    
    override init(name: String) {
        super.init(name: name)
    }
    
    override func fetch(key key: String, formatName: String = HanekeGlobals.Cache.OriginalFormatName, failure fail : Fetch<T>.Failer? = nil, success succeed : Fetch<T>.Succeeder? = nil) -> Fetch<T> {
        if needsToFail {
            fail?(error)
        }
        else {
            succeed?(item!)
        }
        return Fetch<T>()
    }
    
}
