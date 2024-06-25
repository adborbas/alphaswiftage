import Alamofire
import Foundation

class AlphaVantageRequestBuilder {
    private let host: APIHost
    
    init(host: APIHost) {
        self.host = host
    }
    
    func requestForGlobalQuote(symbol: String) -> AlphaVantageRequest {
        var parameters = Parameters()
        parameters.appendFunction(.globalQuote)
        parameters.appendParameter(.symbol, value: symbol)
        return request(for: parameters)
    }
    
    func requestForCurrencyExchangeRate(from: String, to: String) -> AlphaVantageRequest {
        var parameters = Parameters()
        parameters.appendFunction(.currencyExchangeRate)
        parameters.appendParameter(.fromCurrency, value: from)
        parameters.appendParameter(.toCurrency, value: to)
        return request(for: parameters)
    }
    
    func requestForSymbolSearch(keywords: String) -> AlphaVantageRequest {
        var parameters = Parameters()
        parameters.appendFunction(.symbolSearch)
        parameters.appendParameter(.keywords, value: keywords)
        return request(for: parameters)
    }
    
    func requestForDailyAdjustedTimeSeries(symbol: String, outputSize: OutputSize) -> AlphaVantageRequest {
        var parameters = Parameters()
        parameters.appendFunction(.dailyAdjustedTimeSeries)
        parameters.appendParameter(.symbol, value: symbol)
        parameters.appendParameter(.outputSize, value: outputSize.parameterValue)
        return request(for: parameters)
    }
    
    private func request(for parameters: Parameters) -> AlphaVantageRequest {
        var finalParameters = parameters
        finalParameters.appendParameters(host.baseParameters)
        
        return AlphaVantageRequest(url: host.baseURL,
                                   parameters: finalParameters,
                                   headers: host.headers)
    }
    
    fileprivate enum Parameter: String {
        case symbol
        case function
        case fromCurrency = "from_currency"
        case toCurrency = "to_currency"
        case keywords
        case outputSize = "outputsize"
    }
}

fileprivate extension Parameters {
    mutating func appendParameter(_ parameter: AlphaVantageAPI.Parameter, value: String) {
        self[parameter.rawValue] = value
    }
    
    mutating func appendFunction(_ function: AlphaVantageAPI.Function) {
        self["function"] = function.rawValue
    }
    
    mutating func appendParameters(_ parameters: Parameters) {
        parameters.forEach { (key: String, value: Any) in
            self[key] = value
        }
    }
}

fileprivate extension OutputSize {
    var parameterValue: String {
        switch self {
        case .compact: return "compact"
        case .full: return "full"
        }
    }
}
