import Foundation

public struct Quote: Codable, Equatable {
    public let symbol: String
    public let open: Decimal
    public let high: Decimal
    public let low: Decimal
    public let price: Decimal
    public let volume: Int
    public let latestTradingDay: Date
    public let previousClose: Decimal
    public let change: Decimal
    public let changePercent: String

    private enum CodingKeys: String, CodingKey {
        case symbol = "01. symbol"
        case open = "02. open"
        case high = "03. high"
        case low = "04. low"
        case price = "05. price"
        case volume = "06. volume"
        case latestTradingDay = "07. latest trading day"
        case previousClose = "08. previous close"
        case change = "09. change"
        case changePercent = "10. change percent"
    }
    
    init(symbol: String, open: Decimal, high: Decimal, low: Decimal, price: Decimal, volume: Int, latestTradingDay: Date, previousClose: Decimal, change: Decimal, changePercent: String) {
        self.symbol = symbol
        self.open = open
        self.high = high
        self.low = low
        self.price = price
        self.volume = volume
        self.latestTradingDay = latestTradingDay
        self.previousClose = previousClose
        self.change = change
        self.changePercent = changePercent
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        open = try container.decodeUSDecimal(forKey: .open)
        high = try container.decodeUSDecimal(forKey: .high)
        low = try container.decodeUSDecimal(forKey: .low)
        price = try container.decodeUSDecimal(forKey: .price)
        volume = try container.decodeUSInt(forKey: .volume)
        previousClose = try container.decodeUSDecimal(forKey: .previousClose)
        change = try container.decodeUSDecimal(forKey: .change)
        changePercent = try container.decode(String.self, forKey: .changePercent)

        let dateString = try container.decode(String.self, forKey: .latestTradingDay)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .latestTradingDay, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        latestTradingDay = date
    }
}
