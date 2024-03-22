import XCTest
import Alamofire
import Mocker

@testable import AlphaSwiftage

final class AlphaVantageServiceTests: XCTestCase {
    private let apiKey = "whatever"
    
    func testQuote() async throws {
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
        given(response: .quote, for: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)")
        
        // When
        let result = try await service.quote(for: symbol)
        
        // Then
        assertSuccess(result, expectedValue: expectedQuote)
    }
    
    func testCurrencyExchangeRate() async throws {
        // Given
        let service = givenService()
        let base = "EUR"
        let target = "HUF"
        let expectedRate = CurrencyExchangeRate(fromCurrencyCode: base,
                                                fromCurrencyName: "Euro",
                                                toCurrencyCode: target,
                                                toCurrencyName: "Hungarian Forint",
                                                exchangeRate: Decimal(floatLiteral: 393.5),
                                                lastRefreshed: Date(timeIntervalSince1970: 1710096503),
                                                timeZone: TimeZone.gmt,
                                                bidPrice: Decimal(floatLiteral: 393.49),
                                                askPrice: Decimal(floatLiteral: 393.51))
        given(response: .currencyExchangeRate, for: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=\(base)&to_currency=\(target)&apikey=\(apiKey)")
        
        // When
        let result = try await service.currencyExchangeRate(from: base, to: target)
        
        // Then
        assertSuccess(result, expectedValue: expectedRate)
    }
    
    func testSymbolSearchSuccess() async throws {
        // Given
        let keyword = "vwce"
        let expectedSymbol = Symbol(symbol: "VWCE.DEX",
                                    name: "Vanguard FTSE All-World UCITS ETF USD Accumulation",
                                    type: "ETF",
                                    region: "XETRA",
                                    marketOpen: "08:00",
                                    marketClose: "20:00",
                                    timeZone: TimeZone(secondsFromGMT: 60*60*2)!,
                                    currency: "EUR",
                                    matchScore: 0.7273)
        let service = givenService()
        given(response: .symbolSearchSuccess, for: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(apiKey)")
        
        // When
        let result = try await service.symbolSearch(keywords: keyword)
        
        // Then
        assertSuccess(result, expectedValue: [expectedSymbol])
    }
    
    func testSymbolSearchFailure() async throws {
        // Given
        let expectedError = AlphaVantageAPIError(message: "Invalid API call.")
        let keyword = "whatever"
        let service = givenService()
        given(response: .symbolSearchFailure, for: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(apiKey)")
        
        // When
        let result = try await service.symbolSearch(keywords: keyword)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected error but got success!")
        case .failure(let error):
            switch error {
            case .apiError(let apiError):
                XCTAssertEqual(apiError, expectedError)
            case .unknown(let error):
                XCTFail("Expected apiError but got: \(error.localizedDescription)")
            }
        }
    }
    
    private func given(response: MockResponse, for url: String) {
        Mock(url: URL(string: url)!, response: response).register()
    }
    
    private func givenService() -> AlphaVantageService {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        
        return AlphaVantageService(apiKey: "whatever", session: sessionManager)
    }
    
    private func assertSuccess<T>(_ result: Result<T, AlphaVantageError>, expectedValue: T) where T: Equatable {
        switch result {
        case .success(let actualValue):
            XCTAssertEqual(actualValue, expectedValue)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
}
