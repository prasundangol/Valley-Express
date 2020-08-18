//
//  CacheManager.swift
//  SummerProject
//
//  Created by MacBook Air on 8/13/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import Foundation

class CacheManager{
    
    static var cache = [String:Data]()
    
    static func setImageCache(_ url: String, data:Data?){
        
        //Store the image data and use the url as the key
        cache[url] = data
        
    }
    
    static func getImageCache(_ url: String) -> Data? {
        
        //Try to get the data for the specified url
        return cache[url]
        
    }
}
