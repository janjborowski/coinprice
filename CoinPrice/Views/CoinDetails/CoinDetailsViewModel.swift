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

    private let ticker = BehaviorSubject<CoinTicker?>(value: nil)

    let viewFormatter: Observable<CoinDetailsViewFormatter>

    init() {
        viewFormatter = ticker.asObservable()
            .filterNil()
            .map { CoinDetailsViewFormatter(ticker: $0) }
    }

    func configure(ticker: CoinTicker) {
        self.ticker.onNext(ticker)
    }

}
