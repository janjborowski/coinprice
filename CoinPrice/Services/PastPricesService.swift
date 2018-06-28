//
//  HistoricalPriceService.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import RxSwift

final class PastPricesService: Service, PastPricesServiceType {

    private let dataProvider: CoinTickerDataProvider

    init(dataProvider: CoinTickerDataProvider) {
        self.dataProvider = dataProvider
    }

    func pastPrices(ticker: CoinTicker, fiatCurrency: FiatCurrency) -> Observable<[PastPrice]> {
        let path = buildPath("histoday")
        let params = [
            ("fsym", ticker.symbol),
            ("tsym", fiatCurrency.rawValue),
            ("limit", "30")
        ]

        return buildAndMapRequest(method: .get, path: path, params: params)
            .map({ (response: PastPricesResponse) -> [PastPrice] in
                return Array(response.data)
            })
            .do(onNext: { [unowned self] (pastPrices) in
                self.dataProvider.save(ticker: ticker, pastPrices: pastPrices, in: fiatCurrency)
            })
            .catchError { [unowned self] _ -> Observable<[PastPrice]> in
                return Observable.from(optional: self.dataProvider.fetch(ticker: ticker, in: fiatCurrency))
            }
    }

    private func buildPath(_ suffix: String) -> String {
        let rootPath = "https://min-api.cryptocompare.com/data/"
        return rootPath + suffix
    }

}
