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
    
    public func quote(for symbol: String) async -> Result<Quote, AlphaVantageError>  {
        let request = AlphaVantageAPI.globalQuote(symbol: symbol, apiKey: apiKey)
        
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(QuoteResponse.self) { $0.quote }
    }
    
    public func currencyExchangeRate(from base: String, to target: String) async -> Result<CurrencyExchangeRate, AlphaVantageError>  {
        let request = AlphaVantageAPI.currencyExchangeRate(from: base, to: target, apiKey: apiKey)
        
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(CurrencyExchangeRateResponse.self) { $0.exchangeRate }
    }
    
    public func symbolSearch(keywords: String) async -> Result<[Symbol], AlphaVantageError> {
        let request = AlphaVantageAPI.symbolSearch(keywords: keywords, apiKey: apiKey)
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(SearchSymbolResponse.self) { $0.matches }
    }
    
    public func dailyAdjustedTimeSeries(for symbol: String) async -> Result<[String: EquityDailyData], AlphaVantageError> {
        let request = AlphaVantageAPI.dailyAdjustedTimeSeries(symbol: symbol, apiKey: apiKey)
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(TimeSeriesResponse.self) { $0.dailyTimeSeries }
    }
}
