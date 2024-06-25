import XCTest
import Alamofire
import Mocker

@testable import AlphaSwiftage

final class AlphaVantageServiceTests: XCTestCase {
    private let apiKey = "whatever"
    private lazy var mockAPIHost = MockAPIHost()
    
    func testQuote() async {
        // Given
        let service = givenService()
        let symbol = "VWCE.DEX"
        let expectedQuote = Quote(symbol: symbol,
                                  open: Decimal(115.3),
                                  high: Decimal(115.66),
                                  low: Decimal(115.08),
                                  price: Decimal(115.12),
                                  volume: 66012,
                                  latestTradingDay: Date(timeIntervalSince1970: 1709856000),
                                  previousClose: Decimal(115.1),
                                  change: Decimal(0.02),
                                  changePercent: "0.0174%")
        given(response: .quote, for: "\(mockAPIHost.baseURL.absoluteString)?function=GLOBAL_QUOTE&symbol=\(symbol)")
        
        // When
        let result = await service.quote(for: symbol)
        
        // Then
        assertSuccess(result, expectedValue: expectedQuote)
    }
    
    func testCurrencyExchangeRate() async {
        // Given
        let service = givenService()
        let base = "EUR"
        let target = "HUF"
        let expectedRate = CurrencyExchangeRate(fromCurrencyCode: base,
                                                fromCurrencyName: "Euro",
                                                toCurrencyCode: target,
                                                toCurrencyName: "Hungarian Forint",
                                                exchangeRate: Decimal(floatLiteral: 393.5),
                                                lastRefreshed: "2024-03-10 18:48:23",
                                                timeZone: "UTC",
                                                bidPrice: Decimal(floatLiteral: 393.49),
                                                askPrice: Decimal(floatLiteral: 393.51))
        given(response: .currencyExchangeRate, for: "\(mockAPIHost.absoluteBaseURL)?from_currency=\(base)&function=CURRENCY_EXCHANGE_RATE&to_currency=\(target)")
        
        // When
        let result = await service.currencyExchangeRate(from: base, to: target)
        
        // Then
        assertSuccess(result, expectedValue: expectedRate)
    }
    
    func testSymbolSearchSuccess() async {
        // Given
        let keyword = "vwce"
        let expectedSymbol = Symbol(symbol: "VWCE.DEX",
                                    name: "Vanguard FTSE All-World UCITS ETF USD Accumulation",
                                    type: "ETF",
                                    region: "XETRA",
                                    marketOpen: "08:00",
                                    marketClose: "20:00",
                                    timeZone: "UTC+02",
                                    currency: "EUR",
                                    matchScore: 0.7273)
        let service = givenService()
        given(response: .symbolSearchSuccess, for: "\(mockAPIHost.absoluteBaseURL)?function=SYMBOL_SEARCH&keywords=\(keyword)")
        
        // When
        let result = await service.symbolSearch(keywords: keyword)
        
        // Then
        assertSuccess(result, expectedValue: [expectedSymbol])
    }
    
    func testSymbolSearchFailure() async {
        // Given
        let expectedError: AlphaVantageError = .apiError(AlphaVantageAPIError(message: "Invalid API call."))
        let keyword = "whatever"
        let service = givenService()
        given(response: .symbolSearchFailure, for: "\(mockAPIHost.absoluteBaseURL)?function=SYMBOL_SEARCH&keywords=\(keyword)")
        
        // When
        let result = await service.symbolSearch(keywords: keyword)
        
        // Then
        await assertError(result, expectedError: expectedError)
    }
    
    func testDailyTimeSeries() async {
        // Given
        let expectedResult: [String: EquityDailyData] = [
            "2024-06-21" : EquityDailyData(open: 173.97, high: 174.96, low: 171.4, close: 172.46, adjustedClose: 172.46, volume: 10182025, dividendAmount: 0, splitCoefficient: 1.0),
            "2024-06-20": EquityDailyData(open: 174.08, high: 174.28, low: 171.22, close: 173.92, adjustedClose: 173.92, volume: 4723078, dividendAmount: 0, splitCoefficient: 1.0)
        ]
        
        let symbol = "MSFT"
        let service = givenService()
        given(response: .dailyTimeSeriesSuccess, for: "\(mockAPIHost.absoluteBaseURL)?function=TIME_SERIES_DAILY_ADJUSTED&outputsize=compact&symbol=\(symbol)")
        
        // When
        let result = await service.dailyAdjustedTimeSeries(for: symbol)
        
        // Then
        assertSuccess(result, expectedValue: expectedResult)
    }
    
    func test_unexpectedResponse() async {
        // Given
        let symbol = "vwce"
        let service = givenService()
        given(response: .unexpectedResponse, for: "\(mockAPIHost.absoluteBaseURL)?function=GLOBAL_QUOTE&symbol=\(symbol)")
        
        // When
        let result = await service.quote(for: symbol)
        
        // Then
        await assertError(result, expectedError: .unexpectedResponse("{\n    \"this\": [\"is\", \"unexpected\"]\n}\n"))
    }
    
    private func given(response: MockResponse, for url: String) {
        Mock(url: URL(string: url)!, response: response).register()
    }
    
    private func givenService() -> AlphaVantageService {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        
        let requestBuilder = AlphaVantageRequestBuilder(host: mockAPIHost)
        
        return AlphaVantageService(requestBuilder: requestBuilder, session: sessionManager)
    }
    
    private func assertSuccess<T>(_ result: Result<T, AlphaVantageError>, expectedValue: T) where T: Equatable {
        switch result {
        case .success(let actualValue):
            XCTAssertEqual(actualValue, expectedValue)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    private func assertError<T>(_ result: Result<T, AlphaVantageError>, expectedError: AlphaVantageError) async {
        switch result {
        case .success:
            XCTFail("Expected error but got success!")
        case .failure(let error):
            XCTAssertEqual(error, expectedError, "Expected \(expectedError) but got: \(error)")
        }
    }
}

extension AlphaVantageError: Equatable {
    public static func == (lhs: AlphaVantageError, rhs: AlphaVantageError) -> Bool {
        switch (lhs, rhs) {
        case (.apiError(let lhsError), .apiError(let rhsError)):
            return lhsError == rhsError
        case (.unexpectedResponse(let lhsResponse), .unexpectedResponse(let rhsResponse)):
            return lhsResponse == rhsResponse
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

fileprivate class MockAPIHost: APIHost {
    let baseURL = URL(string: "http://test.com")!
    let headers = HTTPHeaders()
    let baseParameters = Parameters()
    
    var absoluteBaseURL: String {
        return baseURL.absoluteString
    }
}
