import Foundation

struct QuoteResponse: Codable {
    let quote: Quote
    
    enum CodingKeys: String, CodingKey {
        case quote = "Global Quote"
    }
}
