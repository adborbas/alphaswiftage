struct CurrencyExchangeRateResponse: Codable {
    let exchangeRate: CurrencyExchangeRate

    enum CodingKeys: String, CodingKey {
        case exchangeRate = "Realtime Currency Exchange Rate"
    }
}
