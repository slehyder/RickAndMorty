//
//  CacheManager.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getCachedData(for key: String) -> Data? {
        return cache.object(forKey: NSString(string: key)) as Data?
    }
    
    func cacheData(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: NSString(string: key))
    }
}
