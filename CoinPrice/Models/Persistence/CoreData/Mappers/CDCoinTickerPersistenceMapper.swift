//
//  CoinTickerPersistenceMapper.swift
//  CoinPrice
//
//  Created by Jan Borowski on 14.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import CoreData

struct CDCoinTickersPersistenceMapper : PersistenceMapper {

    typealias Value = CoinTicker
    typealias Persisted = CDCoinTicker

    private let context : NSManagedObjectContext
    private let quoteMapper : CDQuotePersistenceMapper

    init(context: NSManagedObjectContext) {
        self.context = context
        self.quoteMapper = CDQuotePersistenceMapper(context: context)
    }

    func mapToValue(_ savedEntities: [CDCoinTicker]) -> [CoinTicker] {
        return savedEntities.map { (persisted) in
            let persistedQuotes = persisted.quotes?.allObjects as? [CDQuote]
            return CoinTicker(id: Int(persisted.identifier),
                name: persisted.name ?? "",
                symbol: persisted.symbol ?? "",
                circulatingSupply: persisted.circulatingSupply as Decimal?,
                maxSupply: persisted.maxSupply as Decimal?,
                quotes: quoteMapper.mapToValue(persistedQuotes ?? []))
        }
    }

    func mapToPersisted(_ values: [CoinTicker]) -> [CDCoinTicker] {
        return values.map { (ticker) in
            let cdTicker = CDCoinTicker(context: context)

            cdTicker.identifier = Int32(ticker.id)
            cdTicker.name = ticker.name
            cdTicker.symbol = ticker.symbol
            cdTicker.circulatingSupply = ticker.circulatingSupply as NSDecimalNumber?
            cdTicker.maxSupply = ticker.maxSupply as NSDecimalNumber?
            quoteMapper.mapToPersisted(ticker.quotes).forEach { cdTicker.addToQuotes($0) }

            return cdTicker
        }
    }

}

