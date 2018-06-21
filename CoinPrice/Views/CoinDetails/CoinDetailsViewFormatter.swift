//
//  CoinDetailsViewFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 18.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

struct CoinDetailsViewFormatter {

    private let coinTicker: CoinTicker

    private let priceFormatter = NumberFormatter(type: .price)
    private let bigNumFormatter = NumberFormatter(type: .bigNum)
    private let cryptoFormatter = NumberFormatter(type: .crypto)

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

    var marketCap: String? {
        return formatMoney(coinTicker.quotes.first?.marketCap)
    }

    var volume: String? {
        return formatMoney(coinTicker.quotes.first?.volume24h)
    }

    var circulatingSupply: String? {
        return appendCryptoSymbol(value: coinTicker.circulatingSupply, ticker: coinTicker)
    }

    var maxSupply: String? {
        return appendCryptoSymbol(value: coinTicker.maxSupply, ticker: coinTicker)
    }

    init(ticker: CoinTicker) {
        self.coinTicker = ticker

        if let currency = ticker.quotes.first?.fiatCurrency {
            priceFormatter.configure(for: currency)
            bigNumFormatter.configure(for: currency)
        }
    }

    private func formatMoney(_ value: Decimal?) -> String? {
        if let value = value {
            return bigNumFormatter.string(from: value as NSDecimalNumber)
        } else {
            return nil
        }
    }

    private func appendCryptoSymbol(value: Decimal?, ticker: CoinTicker) -> String? {
        if let value = value,
            let output = cryptoFormatter.string(from: value as NSDecimalNumber) {
            return output + " " + ticker.symbol
        } else {
            return nil
        }
    }

}
