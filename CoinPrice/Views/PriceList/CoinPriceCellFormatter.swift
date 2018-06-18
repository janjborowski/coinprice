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
    private let priceFormatter = NumberFormatter(type: .price)

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
        guard let quote = coinTicker.quotes.first else {
            return nil
        }
        priceFormatter.configure(for: quote.price)
        return priceFormatter.string(from: quote.price as NSDecimalNumber)
    }

    init(ticker: CoinTicker) {
        coinTicker = ticker

        if let currency = ticker.quotes.first?.fiatCurrency {
            priceFormatter.configure(for: currency)
        }
    }

}
