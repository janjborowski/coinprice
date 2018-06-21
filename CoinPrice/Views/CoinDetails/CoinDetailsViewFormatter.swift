//
//  CoinDetailsViewFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 18.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit
import Charts

struct CoinDetailsViewFormatter {

    private let coinTicker: CoinTicker
    private let pastPrices: [PastPrice]?

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

    var chartData: LineChartData {
        return LineChartData(dataSet: computeChartDataSet())
    }

    init(ticker: CoinTicker, pastPrices: [PastPrice]? = nil) {
        self.coinTicker = ticker
        self.pastPrices = pastPrices

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

    private func computeChartValues() -> [ChartDataEntry] {
        guard let pastPrices = self.pastPrices else {
            return []
        }

        return pastPrices.compactMap { price in
                guard let close = price.close else {
                    return nil
                }

                return ChartDataEntry(x: price.time.timeIntervalSince1970, y: Double(truncating: close as NSNumber))
            }
    }

    private func computeChartDataSet() -> LineChartDataSet {
        let values = computeChartValues()
        let dataSet = LineChartDataSet(values: values, label: nil)
        dataSet.axisDependency = .right
        dataSet.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        dataSet.lineWidth = 1.5
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.fillAlpha = 0.26
        dataSet.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        dataSet.drawCircleHoleEnabled = false

        return dataSet
    }

}
