//
//  MainErrorResponse.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

struct MainErrorResponse : BaseErrorResponse {
    
    var error: String
    
    var errorType: ResponseErrorType?
    
    static func cathError(error: Any? = nil) -> MainErrorResponse {
        var message: String = Constants.Strings.errorDefault
        var errorType = ResponseErrorType.none
        
        if error is BaseError {
            let baseError = (error as! BaseError)
            if let errorMessage = baseError.message,
                (baseError.statusCode == 403) {
                if !errorMessage.isEmpty {
                    message = errorMessage
                }
                errorType = ResponseErrorType.unauthorized
            } else {
                if let errorMessage = baseError.message,
                    !errorMessage.isEmpty {
                    message = errorMessage
                }
                errorType = ResponseErrorType.badRequest
            }
        }
        
        return MainErrorResponse(error: message, errorType: errorType)
    }
}
