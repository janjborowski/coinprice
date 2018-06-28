//
//  CoinPriceCellFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 18.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

struct CoinPriceCellFormatter {

    private let coinTicker: CoinTicker
    private let fiatCurrency: FiatCurrency
    private let priceFormatter = NumberFormatter(type: .price)

    private var quote: Quote? {
        return coinTicker.quotes.first { $0.fiatCurrency == fiatCurrency } ?? coinTicker.quotes.first { $0.fiatCurrency == FiatCurrency.base }
    }

    var icon: UIImage? {
        return UIImage(named: coinTicker.symbol.lowercased())
    }

    var name: String {
        return coinTicker.name
    }

    var symbol: String {
        return coinTicker.symbol
    }

    var price: String? {
        guard let quote = self.quote else {
            return nil
        }
        priceFormatter.configure(for: quote.price)
        return priceFormatter.string(from: quote.price as NSDecimalNumber)
    }

    init(ticker: CoinTicker, fiatCurrency: FiatCurrency) {
        coinTicker = ticker
        self.fiatCurrency = fiatCurrency

        if let currency = quote?.fiatCurrency {
            priceFormatter.configure(for: currency)
        }
    }

}
