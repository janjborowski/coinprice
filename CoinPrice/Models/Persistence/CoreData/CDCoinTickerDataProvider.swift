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

    init(coreDataModel: CDModel) {
        self.coreDataModel = coreDataModel
        mapper = CDCoinTickersPersistenceMapper(context: coreDataModel.persistentContainer.viewContext)
    }

    func save(tickers: [CoinTicker]) {
        let tickersToSave = self.mapper.mapToPersisted(tickers)
        let quotes = tickersToSave.compactMap { $0.quotes?.map { $0 } }
        try? self.coreDataModel.persistentContainer.viewContext.save()
    }

    func fetch() -> [CoinTicker] {
        let savedTickers = fetchPersisted()
        return mapper.mapToValue(savedTickers)
    }

    private func fetchPersisted() -> [CDCoinTicker] {
        let cdCoinTickers = try? coreDataModel.persistentContainer.viewContext.fetch(CDCoinTicker.fetchRequest())
        return cdCoinTickers as? [CDCoinTicker] ?? []
    }

}
