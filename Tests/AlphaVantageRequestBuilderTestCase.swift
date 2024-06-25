import XCTest
import Alamofire

@testable import AlphaSwiftage

class AlphaVantageRequestBuilderTestCase: XCTestCase {
    private lazy var mockAPIHost = MockAPIHost()
    
    func testRequestForGlobalQuote() {
        // Given
        let parameters: [String: Any] = [
            "function": "GLOBAL_QUOTE",
            "symbol": "MSFT"
        ]
        let expectedRequest = givenRequest(with: parameters)
        let requestBuilder = givenAlphaVantageRequestBuilder()
        
        // When
        let actualRequest = requestBuilder.requestForGlobalQuote(symbol: "MSFT")
        
        // Then
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    func testRequestForCurrencyExchangeRate() {
        // Given
        let parameters: [String: Any] = [
            "function": "CURRENCY_EXCHANGE_RATE",
            "from_currency": "EUR",
            "to_currency": "HUF"
        ]
        let expectedRequest = givenRequest(with: parameters)
        let requestBuilder = givenAlphaVantageRequestBuilder()
        
        // When
        let actualRequest = requestBuilder.requestForCurrencyExchangeRate(from: "EUR", to: "HUF")
        
        // Then
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    func testRequestForSymbolSearch() {
        // Given
        let parameters: [String: Any] = [
            "function": "SYMBOL_SEARCH",
            "keywords": "yolo"
        ]
        let expectedRequest = givenRequest(with: parameters)
        let requestBuilder = givenAlphaVantageRequestBuilder()
        
        // When
        let actualRequest = requestBuilder.requestForSymbolSearch(keywords: "yolo")
        
        // Then
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    func testRequestForDailyAdjustedTimeSeries() {
        // Given
        let parameters: [String: Any] = [
            "function": "TIME_SERIES_DAILY_ADJUSTED",
            "symbol": "APPL",
            "outputsize": "full"
        ]
        let expectedRequest = givenRequest(with: parameters)
        let requestBuilder = givenAlphaVantageRequestBuilder()
        
        // When
        let actualRequest = requestBuilder.requestForDailyAdjustedTimeSeries(symbol: "APPL", outputSize: .full)
        
        // Then
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    private func givenAlphaVantageRequestBuilder() -> AlphaVantageRequestBuilder {
        return AlphaVantageRequestBuilder(host: mockAPIHost)
    }
    
    private func givenRequest(with parameters: Parameters) -> AlphaVantageRequest {
        var actualParameters = parameters
        actualParameters.appendParameter(for: mockAPIHost)
        return AlphaVantageRequest(url: mockAPIHost.baseURL,
                                                  parameters: actualParameters,
                                                  headers: mockAPIHost.headers)
    }
}

fileprivate class MockAPIHost: APIHost {
    let baseURL = URL(string: "http://test.com")!
    let headers = HTTPHeaders(["headerKey": "headerValue"])
    let baseParameters: [String: Any] = ["parameterKey": "parameterValue"]
}

extension AlphaVantageRequest: Equatable {
    public static func == (lhs: AlphaVantageRequest, rhs: AlphaVantageRequest) -> Bool {
        return lhs.url == rhs.url &&
        (lhs.parameters as? [String: String]) == (rhs.parameters as? [String: String]) &&
        lhs.headers.dictionary == rhs.headers.dictionary
    }
}

fileprivate extension Parameters {
    mutating func appendParameter(for apiHost: APIHost) {
        self[apiHost.baseParameters.first!.key] = apiHost.baseParameters.first!.value
    }
}
