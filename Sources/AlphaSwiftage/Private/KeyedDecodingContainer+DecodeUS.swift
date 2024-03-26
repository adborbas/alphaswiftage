//
//  KeyedDecodingContainer+DecodeUS.swift
//
//
//  Created by Adam Borbas on 26/03/2024.
//

import Foundation

extension KeyedDecodingContainer {
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale(identifier: "en-US")
        return numberFormatter
    }
    
    func decodeUSDecimal(forKey key: K) throws -> Decimal {
        let stringValue = try decode(String.self, forKey: key)
        guard let decimalValue = numberFormatter.number(from: stringValue)?.decimalValue else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected string to be convertible to Decimal")
        }
        return decimalValue
    }
    
    func decodeUSFloat(forKey key: K) throws -> Float {
        let stringValue = try decode(String.self, forKey: key)
        guard let floatValue = numberFormatter.number(from: stringValue)?.floatValue else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected string to be convertible to Float")
        }
        return floatValue
    }
    
    func decodeUSInt(forKey key: K) throws -> Int {
        let stringValue = try decode(String.self, forKey: key)
        guard let intValue = numberFormatter.number(from: stringValue)?.intValue else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected string to be convertible to Int")
        }
        return intValue
    }
}
