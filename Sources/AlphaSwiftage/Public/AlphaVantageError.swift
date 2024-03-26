//
//  AlphaVantageError.swift
//
//
//  Created by Adam Borbas on 22/03/2024.
//

import Foundation

public enum AlphaVantageError: Error, LocalizedError {
    case apiError(AlphaVantageAPIError)
    case unexpectedResponse(String)
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .apiError(let apiError):
            return apiError.errorDescription
        case .unexpectedResponse(let response):
            return response
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

public struct AlphaVantageAPIError: Codable, LocalizedError, Equatable {
    public let message: String
    
    private enum CodingKeys: String, CodingKey {
        case message = "Error Message"
    }
    
    public var errorDescription: String? {
        return message
    }
}
