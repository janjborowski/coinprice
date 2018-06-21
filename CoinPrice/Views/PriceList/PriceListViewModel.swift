//
//  PriceListViewModel.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import RxSwift
import RxCocoa

final class PriceListViewModel {

    private let updateInterval = RxTimeInterval(300)

    private let bag = DisposeBag()
    private let tickerService: TickersServiceType

    private let userRefresh = PublishSubject<Void>()

    let isLoading: Observable<Bool>
    let coinTickers: Observable<[CoinTicker]>

    init(tickerService: TickersServiceType) {
        self.tickerService = tickerService

        let ticker = Observable<Int>.interval(updateInterval, scheduler: MainScheduler.instance).startWith(0)

        coinTickers = Observable.from([
                ticker,
                userRefresh.map { _ in 0 }
            ])
            .merge()
            .flatMap { _ in
                return tickerService.tickers()
            }
            .share()

        isLoading = Observable.from([
                ticker.map { _ in true },
                userRefresh.map { _ in true },
                coinTickers.map { _ in false }
            ])
            .merge()
    }

    func refresh() {
        userRefresh.onNext(())
    }

}
