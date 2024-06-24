import Foundation

enum AlphaVantageAPI {
    enum Function: String {
        case globalQuote = "GLOBAL_QUOTE"
        case currencyExchangeRate = "CURRENCY_EXCHANGE_RATE"
        case symbolSearch = "SYMBOL_SEARCH"
        case dailyAdjustedTimeSeries = "TIME_SERIES_DAILY_ADJUSTED"
    }

    enum Parameter: String {
        case symbol
        case apiKey = "apikey"
        case fromCurrency = "from_currency"
        case toCurrency = "to_currency"
        case keywords
    }
}
