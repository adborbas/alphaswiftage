import Foundation
import Alamofire

public class AlphaVantageService {
    private let apiKey: String
    private let session: Session
    
    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, session: Session())
    }
    
    required init(apiKey: String, session: Session) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func quote(for symbol: String) async throws -> Quote {
        let request = AlphaVantageAPI.globalQuote(symbol: symbol, apiKey: apiKey)
        
        let response = try await session.request(request)
            .serializingDecodable(QuoteResponse.self).value
        return response.quote
    }
    
    public func currencyExchangeRate(from base: String, to target: String) async throws -> CurrencyExchangeRate {
        let request = AlphaVantageAPI.currencyExchangeRate(from: base, to: target, apiKey: apiKey)

        let response = try await session.request(request)
                                   .serializingDecodable(CurrencyExchangeRateResponse.self).value
        return response.exchangeRate
    }
    
    public func symbolSearch(keywords: String) async throws -> [Symbol] {
        let request = AlphaVantageAPI.symbolSearch(keywords: keywords, apiKey: apiKey)
        let response = try await session.request(request)
            .serializingDecodable(SearchSymbolResponse.self).value
        
        return response.matches
        
    }
}
