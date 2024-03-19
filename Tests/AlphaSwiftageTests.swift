import XCTest

import Alamofire
import Mocker

@testable import AlphaSwiftage

final class AlphaSwiftageTests: XCTestCase {
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
        let quote = try await service.quote(for: symbol)
        
        // Then
        XCTAssertEqual(quote, expectedQuote)
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
        let rate = try await service.currencyExchangeRate(from: base, to: target)
        
        // Then
        XCTAssertEqual(rate, expectedRate)
    }
    
    func testSymbolSearch() async throws {
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
        given(response: .symbolSearch, for: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(apiKey)")
        
        // When
        let symbols = try await service.symbolSearch(keywords: keyword)
        
        // Then
        XCTAssertEqual(symbols.count, 2)
        XCTAssertEqual(symbols[1], expectedSymbol)
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
}

enum MockResponse: String {
    case quote = "mockQuoteResponse"
    case currencyExchangeRate = "mockCurrencyExchangeRateeResponse"
    case symbolSearch = "mockSymbolSearch"
    
    var resourcePath: URL {
        return Bundle.test.url(forResource: "Resources/\(rawValue)", withExtension: "json")!
    }
}

extension Mock {
    init(url: URL, response: MockResponse) {
        self.init(url: url,
                  contentType: .json,
                  statusCode: 200,
                  data: [
                    .get : try! Data(contentsOf: response.resourcePath)
                  ])
    }
}

extension Bundle {
    static var test: Bundle {
        let url = Bundle.module.bundleURL
            .deletingLastPathComponent()
            .appending(path: "AlphaSwiftage_AlphaSwiftageTests.bundle")
        return Bundle(url: url)!
    }
}
