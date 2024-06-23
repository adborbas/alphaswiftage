import Alamofire
import Foundation

enum AlphaVantageAPI: URLConvertible {
    private static let baseURLString = "https://www.alphavantage.co/query"
    
    case globalQuote(symbol: String, apiKey: String)
    case currencyExchangeRate(from: String, to: String, apiKey: String)
    case symbolSearch(keywords: String, apiKey: String)
    case dailyAdjustedTimeSeries(symbol: String, apiKey: String)
    
    fileprivate enum Parameter: String {
        case symbol
        case apiKey = "apikey"
        case function
        case fromCurrency = "from_currency"
        case toCurrency = "to_currency"
        case keywords
    }
    
    func asURL() throws -> URL {
        let url = try AlphaVantageAPI.baseURLString.asURL()
        
        switch self {
        case .globalQuote(let symbol, let apiKey):
            return url.appendingParameter(.function, value: "GLOBAL_QUOTE")
                .appendingParameter(.symbol, value: symbol)
                .appendingParameter(.apiKey, value: apiKey)
            
        case .currencyExchangeRate(let base, let target, let apiKey):
            return url.appendingParameter(.function, value: "CURRENCY_EXCHANGE_RATE")
                .appendingParameter(.fromCurrency, value: base)
                .appendingParameter(.toCurrency, value: target)
                .appendingParameter(.apiKey, value: apiKey)
            
        case .symbolSearch(let keywords, let apiKey):
            return url.appendingParameter(.function, value: "SYMBOL_SEARCH")
                .appendingParameter(.keywords, value: keywords)
                .appendingParameter(.apiKey, value: apiKey)
            
        case .dailyAdjustedTimeSeries(let symbol, let apiKey):
            return url.appendingParameter(.function, value: "TIME_SERIES_DAILY_ADJUSTED")
                .appendingParameter(.symbol, value: symbol)
                .appendingParameter(.apiKey, value: apiKey)
        }
    }
}

fileprivate extension URL {
    func appendingParameter(_ parameter: AlphaVantageAPI.Parameter, value: String) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: parameter.rawValue, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
