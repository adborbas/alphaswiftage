# AlphaSwiftage

Lightweight Swift library to access the [Alpha Vantage API](https://www.alphavantage.co/documentation/). The library does also support the [Alpha Vantage API exposed on RapidAPI](https://rapidapi.com/alphavantage/api/alpha-vantage).

## Installation

AlphaSwiftage is distributed using the [Swift Package Manager](https://www.swift.org/documentation/package-manager/). To install it add it as a dependency within your Package.swift manifest:

```swift
dependencies: [
    .package(url: "https://github.com/adborbas/alphaswiftage.git", from: "0.5.0")
]
```

## Usage

Using the native Alpha Vantage API:

```swift
import AlphaSwiftage

let service = AlphaVantageService(apiKey: "{YOUR_API_KEY}")
let symbols = try await service.symbolSearch(keywords: "VWCE")
```

Alpha Vantage API exposed on RapidAPI:

```swift
import AlphaSwiftage

let service = AlphaVantageService(serviceType: .rapidAPI(apiKey: "{YOUR_API_KEY}"))
let symbols = try await service.symbolSearch(keywords: "VWCE")
```

## Supported routes

- [Symbol Search](https://www.alphavantage.co/documentation/#symbolsearch)
- [Quote](https://www.alphavantage.co/documentation/#latestprice)
- [Exchange Rates](https://www.alphavantage.co/documentation/#currency-exchange)
- [Time Series - Daily Adjusted](https://www.alphavantage.co/documentation/#dailyadj)
