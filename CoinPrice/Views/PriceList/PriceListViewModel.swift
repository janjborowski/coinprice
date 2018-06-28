//
//  PriceListViewModel.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import RxSwift

final class PriceListViewModel {

    typealias CellModel = (ticker: CoinTicker, fiatCurrency: FiatCurrency)

    private let updateInterval = RxTimeInterval(300)

    private let bag = DisposeBag()
    private let tickerService: TickersServiceType
    private let settingsDataProvider: SettingsDataProvider

    private let userRefresh = PublishSubject<Void>()
    private let coinTickers: Observable<[CoinTicker]>

    let isLoading: Observable<Bool>
    var cellModels: Observable<[CellModel]> {
        return coinTickers.map { [unowned self] (tickers) in
            let fiatCurrency = self.settingsDataProvider.currency.value
            return tickers.map { (ticker: $0, fiatCurrency: fiatCurrency) }
        }
    }

    init(tickerService: TickersServiceType, settingsDataProvider: SettingsDataProvider) {
        self.tickerService = tickerService
        self.settingsDataProvider = settingsDataProvider

        let timerToUpdate = Observable<Int>.interval(updateInterval, scheduler: MainScheduler.instance).startWith(0)
        let refreshExecutor = Observable.from([
                timerToUpdate,
                userRefresh.map { _ in 0 }
            ])
            .merge()

        coinTickers = Observable.combineLatest(refreshExecutor, settingsDataProvider.currency.asObservable())
            .flatMap { (_, fiatCurrency) in
                return tickerService.tickers(with: fiatCurrency)
            }
            .share()

        isLoading = Observable.from([
                timerToUpdate.map { _ in true },
                userRefresh.map { _ in true },
                coinTickers.map { _ in false }
            ])
            .merge()
    }

    func refresh() {
        userRefresh.onNext(())
    }

}
