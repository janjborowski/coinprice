//
//  Quote\.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

struct Quote: Decodable {

    let price: Decimal
    let volume24h: Decimal
    let marketCap: Decimal
    private let currency: String

    var fiatCurrency : FiatCurrency {
        return FiatCurrency(rawValue: currency) ?? .unknown
    }

    enum CodingKeys: String, CodingKey {

        case price = "price"
        case volume24h = "volume_24h"
        case currency = "currency"
        case marketCap = "market_cap"

    }

    init(price: Decimal, volume24h: Decimal, marketCap: Decimal, currency: String) {
        self.price = price
        self.volume24h = volume24h
        self.currency = currency
        self.marketCap = marketCap
    }

}
