//
//  CoinTickerDataProvider.swift
//  CoinPrice
//
//  Created by Jan Borowski on 15.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

protocol CoinTickerDataProvider {

    func save(tickers: [CoinTicker])

    func fetch() -> [CoinTicker]

    func save(ticker: CoinTicker, pastPrices: [PastPrice], in fiatCurrency: FiatCurrency)

    func fetch(ticker: CoinTicker, in fiatCurrency: FiatCurrency) -> [PastPrice]

}
