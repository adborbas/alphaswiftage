//
//  SearchSymbolResponse.swift
//
//
//  Created by Adam Borbas on 16/03/2024.
//

import Foundation

struct SearchSymbolResponse: Codable {
    let matches: [Symbol]
    
    enum CodingKeys: String, CodingKey {
        case matches = "bestMatches"
    }
}
