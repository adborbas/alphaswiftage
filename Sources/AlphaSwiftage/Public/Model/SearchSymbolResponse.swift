import Foundation

struct SearchSymbolResponse: Codable {
    let matches: [Symbol]
    
    enum CodingKeys: String, CodingKey {
        case matches = "bestMatches"
    }
}
