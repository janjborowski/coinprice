//
//  PricesService.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import RxSwift

final class TickersService: TickersServiceType, Service {

    private let dataProvider: CoinTickerDataProvider

    init(dataProvider: CoinTickerDataProvider) {
        self.dataProvider = dataProvider
    }

    func tickers() -> Observable<[CoinTicker]> {
        let path = buildPath("ticker/")
        let params = [
            ("limit", "10")
        ]
        return buildAndMapRequest(method: .get, path: path, params: params)
            .map({ (response: CoinTickerResponse) -> [CoinTicker] in
                return Array(response.data.values)
            })
            .do(onNext: { [unowned self] (tickers) in
                self.dataProvider.save(tickers: tickers)
            })
            .catchError { [unowned self] _ -> Observable<[CoinTicker]> in
                return Observable.from(optional: self.dataProvider.fetch())
            }
    }

    private func buildPath(_ suffix: String) -> String {
        let rootPath = "https://api.coinmarketcap.com/v2/"
        return rootPath + suffix
    }

}
