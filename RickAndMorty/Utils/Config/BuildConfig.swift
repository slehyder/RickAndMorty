//
//  BuildConfig.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation

enum BuildConfigConstants: String {
    case BASE_URL = "BASE_URL"
}

struct BuildConfig {

    static func getURL(for config: BuildConfigConstants) -> String {
        if let path = infoDict[config.rawValue] as? String {
            return path
        }
        return ""
    }
    
    static func getURL(for config: BuildConfigConstants, path: String) -> String {
        return BuildConfig.getURL(for: config) + path
    }
    
    static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            return [:]
        }
        return dict
    }()

}

