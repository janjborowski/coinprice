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
        return coreDataModel.persistentContainer.viewContext
    }

    init(coreDataModel: CDModel) {
        self.coreDataModel = coreDataModel
        mapper = CDCoinTickersPersistenceMapper(context: coreDataModel.persistentContainer.viewContext)
        pastPricesMapper = CDPastPricePersistenceMapper(context: coreDataModel.persistentContainer.viewContext)
    }

    func save(tickers: [CoinTicker]) {
        let tickersToSave = self.mapper.mapToPersisted(tickers)
        _ = tickersToSave.compactMap { $0.quotes?.map { $0 } }
        try? self.coreDataModel.persistentContainer.viewContext.save()
    }

    func save(ticker: CoinTicker, pastPrices: [PastPrice]) {
        guard let cdTicker = find(with: ticker.id) else {
            return
        }

        _ = pastPricesMapper.mapToPersisted(pastPrices, ticker: cdTicker)
        try? self.coreDataModel.persistentContainer.viewContext.save()
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

    func fetch(coin: CoinTicker) -> [PastPrice] {
        let pastPrices = fetchPersisted(with: coin)
        return pastPricesMapper.mapToValue(pastPrices).sorted { $0.time < $1.time }
    }

    private func fetchPersisted(with coin: CoinTicker) -> [CDPastPrice] {
        guard let cdTicker = find(with: coin.id) else {
            return []
        }

        return cdTicker.pastPrices?.compactMap { $0 as? CDPastPrice } ?? []
    }

    private func find(with id: Int) -> CDCoinTicker? {
        let fetchRequest: NSFetchRequest<CDCoinTicker> = CDCoinTicker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", id as NSNumber)
        let results = try? context.fetch(fetchRequest)
        return results?.first
    }

}
