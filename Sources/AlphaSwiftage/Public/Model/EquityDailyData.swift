import Foundation

public struct EquityDailyData: Codable, Equatable {
    public let open: Decimal
    public let high: Decimal
    public let low: Decimal
    public let close: Decimal
    public let adjustedClose: Decimal
    public let volume: Int
    public let dividendAmount: Decimal
    public let splitCoefficient: Decimal
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
        case volume = "6. volume"
        case dividendAmount = "7. dividend amount"
        case splitCoefficient = "8. split coefficient"
    }
    
    public init(open: Decimal, high: Decimal, low: Decimal, close: Decimal, adjustedClose: Decimal, volume: Int, dividendAmount: Decimal, splitCoefficient: Decimal) {
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.adjustedClose = adjustedClose
        self.volume = volume
        self.dividendAmount = dividendAmount
        self.splitCoefficient = splitCoefficient
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        open = try container.decodeUSDecimal(forKey: .open)
        high = try container.decodeUSDecimal(forKey: .high)
        low = try container.decodeUSDecimal(forKey: .low)
        close = try container.decodeUSDecimal(forKey: .close)
        adjustedClose = try container.decodeUSDecimal(forKey: .adjustedClose)
        volume = try container.decodeUSInt(forKey: .volume)
        dividendAmount = try container.decodeUSDecimal(forKey: .dividendAmount)
        splitCoefficient = try container.decodeUSDecimal(forKey: .splitCoefficient)
    }
}
