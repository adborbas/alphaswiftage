//
//  MockResponse.swift
//
//
//  Created by Adam Borbas on 22/03/2024.
//

import Foundation
import Mocker

enum MockResponse: String {
    case quote = "mockQuoteResponse"
    case currencyExchangeRate = "mockCurrencyExchangeRateeResponse"
    case symbolSearchSuccess = "mockSymbolSearchSuccess"
    case symbolSearchFailure = "mockSymbolSearchFailure"
    case unexpectedResponse = "mockUnexpectedResponse"
    
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
