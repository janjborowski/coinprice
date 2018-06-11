//
//  PricesService.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import RxSwift

class PricesService: PricesServiceType, Service {

    func tickers() -> Observable<[CoinTicker]> {
        let path = buildPath("ticker/")
        let params = [
            ("limit", "10")
        ]
        return buildAndMapRequest(method: .get, path: path, params: params)
            .map({ (response: CoinTickerResponse) -> [CoinTicker] in
                return Array(response.data.values)
            })
            .catchErrorJustReturn([])
    }

    private func buildPath(_ suffix: String) -> String {
        let rootPath = "https://api.coinmarketcap.com/v2/"
        return rootPath + suffix
    }

}
