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
    private let settingsDataProvider: SettingsDataProvider

    private let ticker = BehaviorSubject<CoinTicker?>(value: nil)

    let viewFormatter: Observable<CoinDetailsViewFormatter>

    init(pastPricesService: PastPricesServiceType, settingsDataProvider: SettingsDataProvider) {
        self.pastPricesService = pastPricesService
        self.settingsDataProvider = settingsDataProvider

        let tickerNonNil = ticker.asObservable().filterNil()
        let pastPrices = tickerNonNil
            .flatMap { pastPricesService.pastPrices(ticker: $0, fiatCurrency: settingsDataProvider.currency.value).startWith([]) }

        viewFormatter = Observable.combineLatest(tickerNonNil, pastPrices)
            .map { CoinDetailsViewFormatter(ticker: $0.0, fiatCurrency: settingsDataProvider.currency.value, pastPrices: $0.1) }
            .share(replay: 1)
    }

    func configure(ticker: CoinTicker) {
        self.ticker.onNext(ticker)
    }

}
