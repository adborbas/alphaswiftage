import Alamofire
import Foundation

enum AlphaVantageAPI: URLConvertible {
    private static let baseURLString = "https://www.alphavantage.co/query"

    case globalQuote(symbol: String, apiKey: String)
    case currencyExchangeRate(from: String, to: String, apiKey: String)
    case symbolSearch(keywords: String, apiKey: String)
    case dailyAdjustedTimeSeries(symbol: String, apiKey: String)

       func asURL() throws -> URL {
           let url = try AlphaVantageAPI.baseURLString.asURL()

           switch self {
           case .globalQuote(let symbol, let apiKey):
               return url.appending("function", value: "GLOBAL_QUOTE")
                   .appending("symbol", value: symbol)
                   .appending("apikey", value: apiKey)
           case .currencyExchangeRate(let base, let target, let apiKey):
               return url.appending("function", value: "CURRENCY_EXCHANGE_RATE")
                   .appending("from_currency", value: base)
                   .appending("to_currency", value: target)
                   .appending("apikey", value: apiKey)
           case .symbolSearch(let keywords, let apiKey):
               return url.appending("function", value: "SYMBOL_SEARCH")
                   .appending("keywords", value: keywords)
                   .appending("apikey", value: apiKey)
           case .dailyAdjustedTimeSeries(let symbol, let apiKey):
               return url.appending("function", value: "TIME_SERIES_DAILY_ADJUSTED")
                   .appending("symbol", value: symbol)
                   .appending("apikey", value: apiKey)
           }
       }
}

fileprivate extension URL {
    func appending(_ queryItem: String, value: String) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
