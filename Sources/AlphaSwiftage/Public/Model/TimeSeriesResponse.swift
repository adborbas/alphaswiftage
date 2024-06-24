import Foundation

struct TimeSeriesResponse: Codable {
    let metaData: MetaData
    let dailyTimeSeries: [String: EquityDailyData]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case dailyTimeSeries = "Time Series (Daily)"
    }
}

struct MetaData: Codable {
    let information: String
    let symbol: String
    let lastRefreshed: String
    let outputSize: String
    let timeZone: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case outputSize = "4. Output Size"
        case timeZone = "5. Time Zone"
    }
}
