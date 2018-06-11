//
//  PriceListViewModel.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PriceListViewModel {

    private let updateInterval = RxTimeInterval(300)

    private let bag = DisposeBag()
    private let pricesService: PricesServiceType

    let isLoading = BehaviorRelay<Bool>(value: false)

    let coinTickers : Observable<[CoinTicker]>

    init(pricesService: PricesServiceType) {
        self.pricesService = pricesService

        let ticker = Observable<Int>.interval(updateInterval, scheduler: MainScheduler.instance).startWith(0)

        coinTickers = ticker.flatMap { _ in
                return pricesService.tickers()
            }
            .share()

        Observable.from([
                ticker.map { _ in true },
                coinTickers.map { _ in false }
            ])
            .merge()
            .bind(to: isLoading)
            .disposed(by: bag)
    }

}
