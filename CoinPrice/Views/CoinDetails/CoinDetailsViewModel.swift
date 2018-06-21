//
//  CoinDetailsViewModel.swift
//  CoinPrice
//
//  Created by Jan Borowski on 16.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class CoinDetailsViewModel {

    private let pastPricesService: PastPricesServiceType

    private let ticker = BehaviorSubject<CoinTicker?>(value: nil)

    let viewFormatter: Observable<CoinDetailsViewFormatter>

    init(pastPricesService: PastPricesServiceType) {
        self.pastPricesService = pastPricesService

        let tickerNonNil = ticker.asObservable().filterNil()
        let pastPrices = tickerNonNil
            .flatMap { pastPricesService.pastPrices(ticker: $0, fiatCurrency: .usd) }
            .startWith([])

        viewFormatter = Observable.combineLatest(tickerNonNil, pastPrices)
            .map { CoinDetailsViewFormatter(ticker: $0.0, pastPrices: $0.1) }
            .share()
    }

    func configure(ticker: CoinTicker) {
        self.ticker.onNext(ticker)
    }

}
