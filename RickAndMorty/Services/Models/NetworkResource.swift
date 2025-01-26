//
//  NetworkResource.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation

struct NetworkResource<T> {
    var data: T?
    var error: BaseErrorResponse?

    init(data: T?, error: BaseErrorResponse?) {
        self.data = data
        self.error = error
    }

    init(successData: T) {
        self.data = successData
        self.error = nil
    }

    init(error: BaseErrorResponse) {
        self.data = nil
        self.error = error
    }

    var isSuccess: Bool {
        return data != nil
    }

    var isError: Bool {
        return error != nil
    }
}

protocol BaseErrorResponse {
    var error: String { get }
    var errorType: ResponseErrorType? { get }
}

enum ResponseErrorType {
    case none
    case unauthorized
    case badRequest
    case notAvailable
}
