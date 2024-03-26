//
//  Symbol.swift
//
//
//  Created by Adam Borbas on 16/03/2024.
//

import Foundation

public struct Symbol: Codable, Equatable {
    public let symbol: String
    public let name: String
    public let type: String
    public let region: String
    public let marketOpen: String
    public let marketClose: String
    public let timeZone: TimeZone
    public let currency: String
    public let matchScore: Float

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case region = "4. region"
        case marketOpen = "5. marketOpen"
        case marketClose = "6. marketClose"
        case timeZone = "7. timezone"
        case currency = "8. currency"
        case matchScore = "9. matchScore"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        region = try container.decode(String.self, forKey: .region)
        marketOpen = try container.decode(String.self, forKey: .marketOpen)
        marketClose = try container.decode(String.self, forKey: .marketClose)
        currency = try container.decode(String.self, forKey: .currency)
        self.matchScore = try container.decodeUSFloat(forKey: .matchScore)

        // Handling TimeZone
        let timeZoneString = try container.decode(String.self, forKey: .timeZone)
        guard let timeZone = TimeZone(identifier: timeZoneString) else {
            throw DecodingError.dataCorruptedError(forKey: .timeZone, in: container, debugDescription: "Time zone string is not a valid identifier.")
        }
        self.timeZone = timeZone
    }
    
    init(symbol: String, name: String, type: String, region: String, marketOpen: String, marketClose: String, timeZone: TimeZone, currency: String, matchScore: Float) {
            self.symbol = symbol
            self.name = name
            self.type = type
            self.region = region
            self.marketOpen = marketOpen
            self.marketClose = marketClose
            self.timeZone = timeZone
            self.currency = currency
            self.matchScore = matchScore
        }
}

