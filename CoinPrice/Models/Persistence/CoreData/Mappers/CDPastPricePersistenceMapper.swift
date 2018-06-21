//
//  CDPastPricePersistenceMapper.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import CoreData

struct CDPastPricePersistenceMapper {

    typealias Value = PastPrice
    typealias Persisted = CDPastPrice

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func mapToPersisted(_ values: [PastPrice], ticker: CDCoinTicker) -> [CDPastPrice] {
        let cdPastPrices = values.enumerated().map({ (offset, pastPrice) -> CDPastPrice in
            let cdPastPrice = CDPastPrice(context: context)

            cdPastPrice.index = "\(offset)_" + (ticker.symbol ?? "")
            cdPastPrice.time = pastPrice.time
            cdPastPrice.open = pastPrice.open as NSDecimalNumber?
            cdPastPrice.high = pastPrice.high as NSDecimalNumber?
            cdPastPrice.low = pastPrice.low as NSDecimalNumber?
            cdPastPrice.close = pastPrice.close as NSDecimalNumber?

            return cdPastPrice
        })

        cleanAndUpdateCoinPrices(pastPrices: cdPastPrices, ticker: ticker)
        return cdPastPrices
    }

    func mapToValue(_ savedEntities: [CDPastPrice]) -> [PastPrice] {
        return savedEntities.filter { $0.time != nil }
            .map { (pastPrice) -> PastPrice in
            return PastPrice(
                time: pastPrice.time!,
                open: pastPrice.open as Decimal?,
                high: pastPrice.high as Decimal?,
                low: pastPrice.low as Decimal?,
                close: pastPrice.close as Decimal?
            )
        }
    }

    private func cleanAndUpdateCoinPrices(pastPrices: [CDPastPrice], ticker: CDCoinTicker) {
        ticker.pastPrices?.compactMap { $0 as? NSManagedObject }.forEach { context.delete($0) }
        pastPrices.forEach { ticker.addToPastPrices($0) }
    }

}
