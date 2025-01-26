//
//  ServiceRequest.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation
import UIKit
import Alamofire

struct BaseError: Codable, Error {
    var message: String? = nil
    var statusCode: Int = 0
}

class ServiceRequest {
    
    static func makeRequest<T: Codable>(path: String, method: HTTPMethod, params: Codable? = nil, useCache: Bool = true) async throws -> T {
        let urlRequest = try getUrlRequest(path: path, method: method, params: params)
        let cacheKey = urlRequest.url?.absoluteString ?? ""
        
        if useCache, let cachedData = CacheManager.shared.getCachedData(for: cacheKey) {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: cachedData)
                return decodedResponse
            } catch {
                throw BaseError(message: "Decoding cached data error: \(error.localizedDescription)", statusCode: 0)
            }
        }
        
        let dataResponse = await AF.request(urlRequest).serializingData().response
        let decodedResponse: T = try handleResponse(dataResponse: dataResponse)
        
        if let data = dataResponse.data {
            CacheManager.shared.cacheData(data, for: cacheKey)
        }
        
        return decodedResponse
    }

    private static func getUrlRequest(path: String, method: HTTPMethod, params: Codable? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(BuildConfig.getURL(for: .BASE_URL))\(path)") else {
            throw BaseError(message: "Invalid URL", statusCode: 400)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method

        if let params = params {
            _ = JSONEncoder()
            if var jsonDictionary = try? params.asDictionary() {
                jsonDictionary = jsonDictionary.removingNils()
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: []) {
                    urlRequest.httpBody = jsonData
                }
            }
        }
        
        urlRequest.headers.add(.contentType("application/json"))
        
        return urlRequest
    }

    private static func handleResponse<T: Codable>(dataResponse: DataResponse<Data, AFError>) throws -> T {
        guard let statusCode = dataResponse.response?.statusCode else {
            throw BaseError(message: "No response from server", statusCode: 0)
        }
        
        if (200...299).contains(statusCode) {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: dataResponse.data ?? Data())
                return decodedResponse
            } catch {
                throw BaseError(message: "Decoding error: \(error.localizedDescription)", statusCode: statusCode)
            }
        } else {
            let errorMessage: String
            if let data = dataResponse.data, let errorResponse = try? JSONDecoder().decode(BaseError.self, from: data) {
                errorMessage = errorResponse.message ?? "Unknown error"
            } else {
                errorMessage = "HTTP Error: \(statusCode)"
            }
            throw BaseError(message: errorMessage, statusCode: statusCode)
        }
    }
}



extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Dictionary where Value: Any {
    func removingNils() -> [Key: Any] {
        return self.compactMapValues { $0 }
    }
}
