import Foundation

public struct CurrencyExchangeRate: Codable, Equatable {
    public let fromCurrencyCode: String
    public let fromCurrencyName: String
    public let toCurrencyCode: String
    public let toCurrencyName: String
    public let exchangeRate: Decimal
    public let lastRefreshed: String
    public let timeZone: String
    public let bidPrice: Decimal
    public let askPrice: Decimal
    
    init(fromCurrencyCode: String, fromCurrencyName: String, toCurrencyCode: String, toCurrencyName: String, exchangeRate: Decimal, lastRefreshed: String, timeZone: String, bidPrice: Decimal, askPrice: Decimal) {
        self.fromCurrencyCode = fromCurrencyCode
        self.fromCurrencyName = fromCurrencyName
        self.toCurrencyCode = toCurrencyCode
        self.toCurrencyName = toCurrencyName
        self.exchangeRate = exchangeRate
        self.lastRefreshed = lastRefreshed
        self.timeZone = timeZone
        self.bidPrice = bidPrice
        self.askPrice = askPrice
    }

    enum CodingKeys: String, CodingKey {
        case fromCurrencyCode = "1. From_Currency Code"
        case fromCurrencyName = "2. From_Currency Name"
        case toCurrencyCode = "3. To_Currency Code"
        case toCurrencyName = "4. To_Currency Name"
        case exchangeRate = "5. Exchange Rate"
        case lastRefreshed = "6. Last Refreshed"
        case timeZone = "7. Time Zone"
        case bidPrice = "8. Bid Price"
        case askPrice = "9. Ask Price"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fromCurrencyCode = try container.decode(String.self, forKey: .fromCurrencyCode)
        fromCurrencyName = try container.decode(String.self, forKey: .fromCurrencyName)
        toCurrencyCode = try container.decode(String.self, forKey: .toCurrencyCode)
        toCurrencyName = try container.decode(String.self, forKey: .toCurrencyName)
        exchangeRate = try container.decodeUSDecimal(forKey: .exchangeRate)
        bidPrice = try container.decodeUSDecimal(forKey: .bidPrice)
        askPrice = try container.decodeUSDecimal(forKey: .askPrice)
        timeZone = try container.decode(String.self, forKey: .timeZone)
        lastRefreshed = try container.decode(String.self, forKey: .lastRefreshed)
    }
}
