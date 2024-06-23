# AlphaSwiftage

Lightweight Swift library to access the [Alpha Vantage API](https://www.alphavantage.co/documentation/).

## Installation

AlphaSwiftage is distributed using the [Swift Package Manager](https://www.swift.org/documentation/package-manager/). To install it add it as a dependency within your Package.swift manifest:

```swift
dependencies: [
    .package(url: "https://github.com/adborbas/alphaswiftage.git", from: "0.1.0")
]
```

## Usage

```swift
import AlphaSwiftage

let service = AlphaVantageService(apiKey: "{YOUR_API_KEY}")
let symbols = try await service.symbolSearch(keywords: "VWCE")
```

## Supported routes

- [Symbol Search](https://www.alphavantage.co/documentation/#symbolsearch)
- [Quote](https://www.alphavantage.co/documentation/#latestprice)
- [Exchange Rates](https://www.alphavantage.co/documentation/#currency-exchange)
- [Time Series - Daily Adjusted](https://www.alphavantage.co/documentation/#dailyadj)

## API Key

You can get a free API Key [here](https://www.alphavantage.co/support/#api-key).
