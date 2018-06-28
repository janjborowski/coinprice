//
//  PricesDataProvider.swift
//  CoinPrice
//
//  Created by Jan Borowski on 14.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import CoreData

final class CDCoinTickerDataProvider: CoinTickerDataProvider {

    private let coreDataModel: CDModel
    private let mapper: CDCoinTickersPersistenceMapper
    private let pastPricesMapper: CDPastPricePersistenceMapper

    private var context: NSManagedObjectContext {
        return coreDataModel.context
    }

    init(coreDataModel: CDModel) {
        self.coreDataModel = coreDataModel
        mapper = CDCoinTickersPersistenceMapper(context: coreDataModel.context)
        pastPricesMapper = CDPastPricePersistenceMapper(context: coreDataModel.context)
    }

    func save(tickers: [CoinTicker]) {
        let tickersToSave = self.mapper.mapToPersisted(tickers)
        _ = tickersToSave.compactMap { $0.quotes?.map { $0 } }
        coreDataModel.saveContext()
    }

    func save(ticker: CoinTicker, pastPrices: [PastPrice], in fiatCurrency: FiatCurrency) {
        guard let cdTicker = find(with: ticker.id) else {
            return
        }

        _ = pastPricesMapper.mapToPersisted(pastPrices, ticker: cdTicker, currency: fiatCurrency)
        coreDataModel.saveContext()
    }

    func fetch() -> [CoinTicker] {
        let savedTickers = fetchPersisted()
        return mapper.mapToValue(savedTickers)
    }

    private func fetchPersisted() -> [CDCoinTicker] {
        let fetchRequest: NSFetchRequest<CDCoinTicker> = CDCoinTicker.fetchRequest()
        let cdCoinTickers = try? context.fetch(fetchRequest)
        return cdCoinTickers ?? []
    }

    func fetch(ticker: CoinTicker, in fiatCurrency: FiatCurrency) -> [PastPrice] {
        let pastPrices = fetchPersisted(with: ticker, in: fiatCurrency)
        return pastPricesMapper.mapToValue(pastPrices).sorted { $0.time < $1.time }
    }

    private func fetchPersisted(with ticker: CoinTicker, in fiatCurrency: FiatCurrency) -> [CDPastPrice] {
        guard let cdTicker = find(with: ticker.id) else {
            return []
        }
        let pastPrices = cdTicker.quotes?
            .compactMap { $0 as? CDQuote }
            .first { $0.currency! == fiatCurrency.rawValue }
            .map { $0.pastPrices?.compactMap { $0 as? CDPastPrice } }

        if let savedPrices = pastPrices {
            return savedPrices ?? []
        } else {
            return []
        }
    }

    private func find(with id: Int) -> CDCoinTicker? {
        let fetchRequest: NSFetchRequest<CDCoinTicker> = CDCoinTicker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", id as NSNumber)
        let results = try? context.fetch(fetchRequest)
        return results?.first
    }

}
