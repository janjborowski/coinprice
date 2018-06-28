//
//  CoinTickerPersistenceMapper.swift
//  CoinPrice
//
//  Created by Jan Borowski on 14.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import CoreData

struct CDCoinTickersPersistenceMapper: PersistenceMapper {

    typealias Value = CoinTicker
    typealias Persisted = CDCoinTicker

    private let context: NSManagedObjectContext
    private let quoteMapper: CDQuotePersistenceMapper

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
            let cdTicker: CDCoinTicker
            if let existingTicker = findPersistedObjectBy(id: ticker.id) {
                cdTicker = existingTicker
            } else {
                cdTicker = CDCoinTicker(context: context)
            }
            updateQuotes(of: cdTicker, with: ticker)

            cdTicker.identifier = Int32(ticker.id)
            cdTicker.name = ticker.name
            cdTicker.symbol = ticker.symbol
            cdTicker.circulatingSupply = ticker.circulatingSupply as NSDecimalNumber?
            cdTicker.maxSupply = ticker.maxSupply as NSDecimalNumber?

            return cdTicker
        }
    }

    private func findPersistedObjectBy(id: Int) -> CDCoinTicker? {
        let fetchRequest: NSFetchRequest<CDCoinTicker> = CDCoinTicker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", id as NSNumber)
        let results = try? context.fetch(fetchRequest)
        return results?.first
    }

    private func updateQuotes(of savedTicker: CDCoinTicker, with valueTicker: CoinTicker) {
        let savedQuotes = savedTicker.quotes?.compactMap { $0 as? CDQuote } ?? []
        let newQuotes = quoteMapper.mapToPersisted(valueTicker.quotes)
        for newQuote in newQuotes {
            for savedQuote in savedQuotes {
                if let pastPrices = savedQuote.pastPrices, newQuote.currency == savedQuote.currency {
                    newQuote.addToPastPrices(pastPrices)
                }
            }
        }

        savedQuotes.forEach { quote in
            context.delete(quote)
            savedTicker.removeFromQuotes(quote)
        }

        newQuotes.forEach { savedTicker.addToQuotes($0) }
    }

}
