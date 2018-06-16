//
//  QuotePersistenceMapper.swift
//  CoinPrice
//
//  Created by Jan Borowski on 14.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import CoreData

struct CDQuotePersistenceMapper: PersistenceMapper {

    typealias Value = Quote
    typealias Persisted = CDQuote

    private let context : NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func mapToValue(_ savedEntities: [CDQuote]) -> [Quote] {
        return savedEntities.map { (quote) -> Quote in
            return Quote(
                price: quote.price?.decimalValue ?? .leastNonzeroMagnitude,
                volume24h: quote.volume24h?.decimalValue ?? .leastNonzeroMagnitude,
                marketCap: quote.marketCap?.decimalValue ?? .leastNonzeroMagnitude,
                currency: quote.currency ?? ""
            )
        }
    }

    func mapToPersisted(_ values: [Quote]) -> [CDQuote] {
        return values.map { (quote) in
            let cdQuote = CDQuote(context: context)

            cdQuote.currency = quote.fiatCurrency.rawValue
            cdQuote.price = quote.price as NSDecimalNumber
            cdQuote.volume24h = quote.volume24h as NSDecimalNumber
            cdQuote.marketCap = quote.marketCap as NSDecimalNumber

            return cdQuote
        }
    }

}
