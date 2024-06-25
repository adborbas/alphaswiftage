import Foundation
import Alamofire

public class AlphaVantageService {
    private let requestBuilder: AlphaVantageRequestBuilder
    private let session: Session
    
    public convenience init(apiKey: String) {
        self.init(serviceType: .native(apiKey: apiKey))
    }
    
    public convenience init(serviceType: AlphaVantageServiceType) {
        let host = APIHostFactory.shared.host(for: serviceType)
        let requestBuilder = AlphaVantageRequestBuilder(host: host)
        self.init(requestBuilder: requestBuilder, session: Session())
    }
    
    required init(requestBuilder: AlphaVantageRequestBuilder, session: Session) {
        self.requestBuilder = requestBuilder
        self.session = session
    }
    
    public func quote(for symbol: String) async -> Result<Quote, AlphaVantageError>  {
        let request = requestBuilder.requestForGlobalQuote(symbol: symbol)
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(QuoteResponse.self) { $0.quote }
    }
    
    public func currencyExchangeRate(from base: String, to target: String) async -> Result<CurrencyExchangeRate, AlphaVantageError>  {
        let request = requestBuilder.requestForCurrencyExchangeRate(from: base, to: target)
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(CurrencyExchangeRateResponse.self) { $0.exchangeRate }
    }
    
    public func symbolSearch(keywords: String) async -> Result<[Symbol], AlphaVantageError> {
        let request = requestBuilder.requestForSymbolSearch(keywords: keywords)
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(SearchSymbolResponse.self) { $0.matches }
    }
    
    public func dailyAdjustedTimeSeries(for symbol: String, outputSize: OutputSize) async -> Result<[String: EquityDailyData], AlphaVantageError> {
        let request = requestBuilder.requestForDailyAdjustedTimeSeries(symbol: symbol, outputSize: outputSize)
        return await session.request(request)
            .serializingAlphaVantageWrappedResponse(TimeSeriesResponse.self) { $0.dailyTimeSeries }
    }
    
    public func dailyAdjustedTimeSeries(for symbol: String) async -> Result<[String: EquityDailyData], AlphaVantageError> {
        await dailyAdjustedTimeSeries(for: symbol, outputSize: .compact)
    }
}

extension Session {
    func request(_ request: AlphaVantageRequest) -> DataRequest {
        self.request(request.url, parameters: request.parameters, headers: request.headers)
    }
}
