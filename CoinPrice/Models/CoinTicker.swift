//
//  CoinTicker.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

struct CoinTicker: Decodable {

    let id: Int
    let name: String
    let symbol: String

    private let quotes: [String: Quote]
    var currencyQuotes: [FiatCurrency: Quote] {
        let keyValues = quotes.map { (key, value) in (FiatCurrency(rawValue: key), value) }
        return Dictionary(uniqueKeysWithValues: keyValues.filter { $0.0 != nil }.map { ($0.0!, $0.1) })
    }

}
