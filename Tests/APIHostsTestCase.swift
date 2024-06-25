import XCTest
import Alamofire

@testable import AlphaSwiftage

class APIHostsTestCase: XCTestCase {
    
    func testNativeAPIHost() {
        let apiKey = "daApiKey"
        let host = NativeAPIHost(apiKey: apiKey)
        
        XCTAssertEqual(host.baseURL.absoluteString, "https://www.alphavantage.co/query")
        XCTAssertEqual(host.headers.dictionary, HTTPHeaders().dictionary)
        XCTAssertEqual(host.baseParameters as! [String: String], ["apikey": apiKey])
    }
    
    func testRapidAPIHost() {
        let apiKey = "theApiKey"
        let host = RapidAPIHost(apiKey: apiKey)
        
        XCTAssertEqual(host.baseURL.absoluteString, "https://alpha-vantage.p.rapidapi.com/query")
        XCTAssertEqual(host.headers.dictionary, HTTPHeaders([
            "x-rapidapi-host": "alpha-vantage.p.rapidapi.com",
            "x-rapidapi-key": apiKey
        ]).dictionary)
        XCTAssertEqual(host.baseParameters as! [String: String], [:])
    }
}
