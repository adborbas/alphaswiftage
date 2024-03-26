//
//  AlphaVantageError.swift
//
//
//  Created by Adam Borbas on 22/03/2024.
//

import Foundation

public enum AlphaVantageError: Error {
    case apiError(AlphaVantageAPIError)
    case unexpectedResponse(String)
    case unknown(Error)
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
