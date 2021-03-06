//
//  CoinTicker.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

struct CoinTicker {

    let id: Int
    let name: String
    let symbol: String
    let circulatingSupply: Decimal?
    let maxSupply: Decimal?
    let quotes: [Quote]

    init(id: Int, name: String, symbol: String, circulatingSupply: Decimal?, maxSupply: Decimal?, quotes: [Quote]) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.circulatingSupply = circulatingSupply
        self.maxSupply = maxSupply
        self.quotes = quotes
    }

}

extension CoinTicker: Decodable {

    enum CoinTickerCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case circulatingSupply = "circulating_supply"
        case maxSupply = "max_supply"
        case quotes = "quotes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoinTickerCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let circulatingSupply = try? container.decode(Decimal.self, forKey: .circulatingSupply)
        let maxSupply = try? container.decode(Decimal.self, forKey: .maxSupply)

        let rawQuotes = try container.decode([String: Any].self, forKey: .quotes)
        let quotes = rawQuotes?.compactMap { (key, anyValue) -> Quote? in
            guard var mutableValues = anyValue as? [String: Any] else {
                return nil
            }
            mutableValues[Quote.CodingKeys.currency.rawValue] = key
            do {
                let data = try JSONSerialization.data(withJSONObject: mutableValues, options: .prettyPrinted)
                let decoder = JSONDecoder()
                return try decoder.decode(Quote.self, from: data)
            } catch {
                return nil
            }
        } ?? []

        self.init(
            id: id,
            name: name,
            symbol: symbol,
            circulatingSupply: circulatingSupply,
            maxSupply: maxSupply,
            quotes: quotes
        )
    }

}
